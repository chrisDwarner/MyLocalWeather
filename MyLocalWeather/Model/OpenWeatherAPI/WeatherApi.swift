//
//  WeatherApi.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/30/22.
//

import Foundation
import CoreLocation
import SwiftUI


struct OneCall: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds:Clouds
    let dt: Int
    let sys:Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Main: Codable  {
    private enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case temp = "temp"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Int?
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
