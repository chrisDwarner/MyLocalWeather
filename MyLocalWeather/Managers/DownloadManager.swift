//
//  DownloadManager.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/30/22.
//

import Foundation
import Combine
import SwiftUI

class DownloadManager {
    static var shared: DownloadManager { DownloadManager() }
    
    // openWeather.org apiKey
    fileprivate let apiKey = "84431f2f4742d2281cb6c91f46e2074e"
    var subscriber: Cancellable? = nil
    
    private init() {}
    
    func fetchOneCall(for city: City, block: @escaping (OneCall?, Error?)->Void ) {
        guard let location = city.location?.queryString,
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appId=\(apiKey)\(location)") else { return }

        let publisher = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= status else {
                return
            }
            guard let data = data else { return }
            do {
                print( String(decoding: data, as: UTF8.self))
                let values = try JSONDecoder().decode(OneCall.self, from: data)
                print(values)
            }
            catch {
                print(error)
            }

        }
        publisher.resume()
    }
    
    
}

extension Location {
    
    var queryString: String { "&lat=\(self.lat)&lon=\(self.long)" }
}


extension DownloadManager {

    enum APIError: Error, LocalizedError {
        case unknown, apiError(reason: String)
        var errorDescription: String? {
            switch self {
            case .unknown:
                return "Unknown error"
            case .apiError(let reason):
                return reason
            }
        }
    }
    
    func fetch(url: URL) -> AnyPublisher<Data, APIError> {
        let request = URLRequest(url: url)
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return data
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
