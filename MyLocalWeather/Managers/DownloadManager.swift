//
//  DownloadManager.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/30/22.
//

import Foundation
import Combine

class DownloadManager {
    static var shared: DownloadManager { DownloadManager() }
    
    // openWeather.org apiKey
    fileprivate let apiKey = "84431f2f4742d2281cb6c91f46e2074e"
    var subscriber: Cancellable? = nil
    
    private init() {}
    
    func fetchOneCall(for city: City, block: @escaping (OneCall?, Error?)->Void ) {
        guard let location = city.location?.queryString,
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appId=\(apiKey)\(location)") else { return }
        
        // TODO: save the publisher
//        let session = URLSession.shared
//            .dataTaskPublisher(for: url)
//            .tryMap { element -> Data in
//                guard let httpResponse = element.response as? HTTPURLResponse,
//                      httpResponse.statusCode == 200 else {
//                          throw URLError(.badServerResponse)
//                      }
//                return element.data
//            }
//            .decode(type: OneCall.self, decoder: JSONDecoder())
//
//        _ = session.sink(receiveCompletion: { print("received:\n \($0)") }, receiveValue: {
//
//                // $0 should be the OneCall struct
//                print("received OneCall results: \($0)")
//            })
//
        // Usage
//        guard let url = URL(string: "https://www.amazon.com") else { return }
        let sub = fetch(url: url)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, receiveValue: { data in
            guard let response = String(data: data, encoding: .utf8) else { return }
            print(response)
        })
        subscriber = sub
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
