//
//  DownloadManager.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/30/22.
//

import Foundation
import Combine
import RealmSwift
import SwiftUI


class DownloadManager: ObservableObject {
    static var shared: DownloadManager { DownloadManager() }
    
    // openWeather.org apiKey
    fileprivate let apiKey = "84431f2f4742d2281cb6c91f46e2074e"

    private init() {}
    
    func fetchOneCall(for city: City, block: @escaping (OneCall?, Error?)->Void ) {
        guard let location = city.location?.queryString,
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appId=\(apiKey)\(location)") else {
                  block(nil, APIError.apiError(reason: "bad URL request"))
                  return
              }

        let publisher = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                block( nil, error)
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= status else {
                block(nil, APIError.apiError(reason: "bad HTTP response"))
                return
            }
            guard let data = data else { return }
            do {
                let values = try JSONDecoder().decode(OneCall.self, from: data)
                block( values, nil )
            }
            catch {
                block( nil, error)
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
}
