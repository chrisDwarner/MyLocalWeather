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
    
    func fetchWeather(for city: City, block: @escaping (WeatherApi?, Error?)->Void ) {
        guard let location = city.location?.queryString,
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appId=\(apiKey)\(location)") else {
                  block(nil, APIError.apiError(reason: "bad URL request"))
                  return
              }

        fetch( url ) { (data, error) in
            if let _ = error {
                block( nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let values = try JSONDecoder().decode(WeatherApi.self, from: data)
                block( values, nil )
            }
            catch {
                block( nil, error)
            }
        }
    }
    
    func fetchWeatherIcon(_ icon: String, block: @escaping (UIImage)->Void ) {
        guard let url = URL(string: "https://openweathermap.org/img/w/\(icon).png") else {
            return
        }

        fetch( url ) { (data, error) in
            if let _ = error {
                return
            }

            guard let data = data else { return }
            if let iconImage = UIImage(data: data) {
                block( iconImage )
            }
        }
    }
    
    func fetchOneCall(for city: City, block: @escaping (OneCallApi?, Error?)->Void ) {
        guard let location = city.location?.queryString,
              let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?appId=\(apiKey)\(location)") else {
                  block(nil, APIError.apiError(reason: "bad URL request"))
                  return
              }

        fetch( url ) { (data, error ) in
            if let _ = error {
                block( nil, error)
                return
            }
            guard let data = data else { return }
            do {
                let values = try JSONDecoder().decode(OneCallApi.self, from: data)
                block( values, nil )
            }
            catch DecodingError.keyNotFound {
                
            }
            catch {
                print(error)
                block( nil, error)
            }
        }
    }
}

// exclusive private computed vars used in constructing a URL
extension Location {
    
    fileprivate var queryString: String { "&lat=\(self.lat)&lon=\(self.long)" }
}

extension DownloadManager {

    fileprivate func fetch(_ url: URL, block: @escaping (Data?, Error?)->Void ) {
        let publisher = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                block(nil, error)
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= status else {
                block(nil, APIError.apiError(reason: "Bad response from server"))
                return
            }
            guard let data = data else { return }
            block( data, nil)
        }
        publisher.resume()

    }
    
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

