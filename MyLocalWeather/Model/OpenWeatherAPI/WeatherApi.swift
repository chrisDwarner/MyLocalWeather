//
//  WeatherApi.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/30/22.
//

import Foundation
import CoreLocation
import SwiftUI


struct WeatherApi: Codable {
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
    
    init(coord: Coord = Coord(),
         weather: [Weather] = [],
         base: String = "",
         main: Main = Main(),
         visibility: Int = 0,
         wind: Wind = Wind(),
         clouds:Clouds = Clouds(),
         dt: Int = 0,
         sys:Sys = Sys(),
         timezone: Int = 0,
         id: Int = 0,
         name: String = "",
         cod: Int = 0) {
        self.coord = coord
        self.weather = weather
        self.base = base
        self.main = main
        self.visibility = visibility
        self.wind = wind
        self.clouds = clouds
        self.dt = dt
        self.sys = sys
        self.timezone = timezone
        self.id = id
        self.name = name
        self.cod = cod
    }
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
    
    init(lon: Double = 0.0, lat: Double = 0.0) {
        self.lon = lon
        self.lat = lat
    }
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
    
    init( temp: Double = 0,
          feelsLike: Double = 0,
          tempMin: Double = 0,
          tempMax: Double = 0,
          pressure: Int = 0,
          humidity: Int = 0){
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
    
    private enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
        case gust = "gust"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            speed = try container.decode(Double.self, forKey: .speed)
        }
        catch DecodingError.typeMismatch {
            // sometimes the wind speeds could be interpreted as Ints.  I see that behavior in the gust measurement
            speed = try Double( container.decode(Int.self, forKey: .speed))
        }
        
        deg = try container.decode(Int.self, forKey: .deg)
        
        do {
            gust = try container.decode(Double.self, forKey: .gust)
        }
        catch DecodingError.typeMismatch {
            // sometimes the wind gusts are interpreted as Ints
            do  {
                gust = try Double( container.decode(Int.self, forKey: .gust))
            }
            catch {
                // we tried to get the number value and failed, so just assign zero and move on.
                gust = 0.0
            }
        }
        catch DecodingError.keyNotFound {
            gust = 0.0
        }
    }
    
    init(speed: Double = 0,
         deg: Int = 0,
         gust: Double = 0) {
        self.speed = speed
        self.deg = deg
        self.gust = gust
    }
}

struct Clouds: Codable {
    let all: Int
    
    init( all: Int = 0) {
        self.all = all
    }
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
    
    init(type: Int = 0,
         id: Int = 0,
         country: String = "",
         sunrise: Int = 0,
         sunset: Int = 0){
        self.type = type
        self.id = id
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    init( id: Int = 0,
          main: String = "",
          description: String = "",
          icon: String = "") {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}
