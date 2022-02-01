//
//  OneCallApi.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/31/22.
//

import Foundation
import CoreLocation
import SwiftUI


struct OneCallApi: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: Current
    let minutely: [Minutely]
    let hourly: [Hourly]
    let daily: [Daily]
    
    private enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
        case timezone = "timezone"
        case timezone_offset = "timezone_offset"
        case current = "current"
        case minutely = "minutely"
        case hourly = "hourly"
        case daily = "daily"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lat = try container.decode( Double.self, forKey: .lat)
        self.lon = try container.decode( Double.self, forKey: .lon)
        self.timezone = try container.decode( String.self, forKey: .timezone)
        self.timezone_offset = try container.decode( Int.self, forKey: .timezone_offset)
        self.current = try container.decode( Current.self, forKey: .current)
        self.minutely = try container.decode( [Minutely].self, forKey: .minutely)
        self.hourly = try container.decode( [Hourly].self, forKey: .hourly)
        self.daily = try container.decode( [Daily].self, forKey: .daily)
    }
    
    init(lat: Double = 0.0,
         lon: Double = 0.0,
         timezone: String = "",
         timezone_offset: Int = 0,
         current: Current = Current(),
         minutely: [Minutely] = [],
         hourly: [Hourly] = [],
         daily: [Daily] = [] ) {
        self.lat = lat
        self.lon = lon
        self.timezone = timezone
        self.timezone_offset = timezone_offset
        self.current = current
        self.minutely = minutely
        self.hourly = hourly
        self.daily = daily
    }
    
    var dailyTempChartData: [TempMinMaxModel] {

        var dataSet: [TempMinMaxModel] = []
        daily.forEach { day in
            dataSet.append( TempMinMaxModel(month: day.dt.dayString, value: day.temp.min.kelvinInF, name: "Min Temp") )
        }

        daily.forEach { day in
            dataSet.append( TempMinMaxModel(month: day.dt.dayString, value: day.temp.max.kelvinInF, name: "Max Temp") )
        }
        return dataSet
    }
    
    var hourlyObservations: [HourlyModel] {
        var observations: [HourlyModel] = []
        
        hourly.forEach { hourly in
            if let icon = hourly.weather.first?.icon {
                observations.append(HourlyModel(icon: icon,
                                                timeStamp: hourly.dt.timeString,
                                                temp: hourly.temp.tempInF,
                                                visiblity: "\(hourly.visibility)"))
            }
        }
        
        return observations
    }

}

struct Current: Codable {
    
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [Weather]
    
    init(dt: Int = 0,
         sunrise: Int = 0,
         sunset: Int = 0,
         temp: Double = 0.0,
         feels_like: Double = 0.0,
         pressure: Int = 0,
         humidity: Int = 0,
         dew_point: Double = 0.0,
         uvi: Double = 0.0,
         clouds: Int = 0,
         visibility: Int = 0,
         wind_speed: Double = 0.0,
         wind_deg: Int = 0,
         wind_gust: Double = 0.0,
         weather: [Weather] = []) {
        
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feels_like = feels_like
        self.pressure = pressure
        self.humidity = humidity
        self.dew_point = dew_point
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.wind_speed = wind_speed
        self.wind_deg = wind_deg
        self.wind_gust = wind_gust
        self.weather = weather
    }
}

struct Minutely: Codable {
    let dt: Int
    let precipitation: Double
    
    private enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case precipitation = "precipitation"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        dt = try container.decode(Int.self, forKey: .dt)
        
        do {
            precipitation = try container.decode(Double.self, forKey: .precipitation)
        }
        catch DecodingError.typeMismatch {
            // sometimes the wind speeds could be interpreted as Ints.  I see that behavior in the gust measurement
            precipitation = try Double( container.decode(Int.self, forKey: .precipitation))
        }
        catch DecodingError.keyNotFound {
            precipitation = 0.0
        }
    }
    
    init( dt: Int = 0, precipitation: Double = 0.0 ) {
        self.dt = dt
        self.precipitation = precipitation
    }
}

struct Hourly: Codable, Identifiable {
    var id: UUID = UUID()

    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [Weather]
    let pop: Double
    
    private enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case temp = "temp"
        case feels_like = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case dew_point = "dew_point"
        case uvi = "uvi"
        case clouds = "clouds"
        case visibility = "visibility"
        case wind_speed = "wind_speed"
        case wind_deg = "wind_deg"
        case wind_gust = "wind_gust"
        case weather = "weather"
        case pop = "pop"
    }
    
    init(from decoder: Decoder) throws {
        self.id = UUID()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.temp = try container.decode( Double.self, forKey: .temp)
        self.feels_like = try container.decode( Double.self, forKey: .feels_like)
        self.pressure = try container.decode( Int.self, forKey: .pressure)
        self.humidity = try container.decode( Int.self, forKey: .humidity)
        self.dew_point = try container.decode( Double.self, forKey: .dew_point)
        self.uvi = try container.decode( Double.self, forKey: .uvi)
        self.clouds = try container.decode( Int.self, forKey: .clouds)
        self.visibility = try container.decode( Int.self, forKey: .visibility)
        self.wind_speed = try container.decode( Double.self, forKey: .wind_speed)
        self.wind_deg = try container.decode( Int.self, forKey: .wind_deg)
        self.wind_gust = try container.decode( Double.self, forKey: .wind_gust)
        self.weather = try container.decode( [Weather].self, forKey: .weather)
        
        do {
            self.pop = try container.decode( Double.self, forKey: .pop)
        }
        catch DecodingError.typeMismatch {
            // sometimes the wind speeds could be interpreted as Ints.  I see that behavior in the gust measurement
            
            self.pop = try Double( container.decode( Int.self, forKey: .pop))
        }
        catch DecodingError.keyNotFound {
            self.pop = 0.0
        }
    }

    init(dt: Int = 0,
         temp: Double = 0.0,
         feels_like: Double = 0.0,
         pressure: Int = 0,
         humidity: Int = 0,
         dew_point: Double = 0.0,
         uvi: Double = 0.0,
         clouds: Int = 0,
         visibility: Int = 0,
         wind_speed: Double = 0.0,
         wind_deg: Int = 0,
         wind_gust: Double = 0.0,
         weather: [Weather] = [],
         pop: Double = 0 ) {

        self.id = UUID()
        self.dt = dt
        self.temp = temp
        self.feels_like = feels_like
        self.pressure = pressure
        self.humidity = humidity
        self.dew_point = dew_point
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.wind_speed = wind_speed
        self.wind_deg = wind_deg
        self.wind_gust = wind_gust
        self.weather = weather
        self.pop = pop
    }
}

struct Daily: Codable, Identifiable {
    var id: ObjectIdentifier
    
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let moonrise: Int
    let moonset: Int
    let moon_phase: Double
    let temp: Temp
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let uvi: Double
    
    
    private enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case moonrise = "moonrise"
        case moonset = "moonset"
        case moon_phase = "moon_phase"
        case temp = "temp"
        case feels_like = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case dew_point = "dew_point"
        case wind_speed = "wind_speed"
        case wind_deg = "wind_deg"
        case wind_gust = "wind_gust"
        case weather = "weather"
        case clouds = "clouds"
        case pop = "pop"
        case uvi = "uvi"
    }
    
    init(from decoder: Decoder) throws {
        
        self.id = ObjectIdentifier(Daily.self)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.dt = try container.decode( Int.self, forKey: .dt )
        self.sunrise = try container.decode( Int.self, forKey: .sunrise )
        self.sunset = try container.decode( Int.self, forKey: .sunset )
        self.moonrise = try container.decode( Int.self, forKey: .moonrise )
        self.moonset = try container.decode( Int.self, forKey: .moonset )
        self.moon_phase = try container.decode( Double.self, forKey: .moon_phase )
        self.temp = try container.decode( Temp.self, forKey: .temp )
        self.feels_like = try container.decode( FeelsLike.self, forKey: .feels_like )
        self.pressure = try container.decode( Int.self, forKey: .pressure )
        self.humidity = try container.decode( Int.self, forKey: .humidity )
        self.dew_point = try container.decode( Double.self, forKey: .dew_point )
        self.wind_speed = try container.decode( Double.self, forKey: .wind_speed )
        self.wind_deg = try container.decode( Int.self, forKey: .wind_deg )
        self.wind_gust = try container.decode( Double.self, forKey: .wind_gust )
        self.weather = try container.decode( [Weather].self, forKey: .weather )
        self.clouds = try container.decode( Int.self, forKey: .clouds )

        do {
            self.pop = try container.decode( Double.self, forKey: .pop)
        }
        catch DecodingError.typeMismatch {
            // sometimes the wind speeds could be interpreted as Ints.  I see that behavior in the gust measurement
            
            self.pop = try Double( container.decode( Int.self, forKey: .pop))
        }
        catch DecodingError.keyNotFound {
            self.pop = 0.0
        }

        self.uvi = try container.decode( Double.self, forKey: .uvi )
    }
    
    init(
        dt: Int = 0,
        sunrise: Int = 0,
        sunset: Int = 0,
        moonrise: Int = 0,
        moonset: Int = 0,
        moon_phase: Double = 0,
        temp: Temp = Temp(),
        feels_like: FeelsLike = FeelsLike(),
        pressure: Int = 0,
        humidity: Int = 0,
        dew_point: Double = 0,
        wind_speed: Double = 0,
        wind_deg: Int = 0,
        wind_gust: Double = 0,
        weather: [Weather] = [],
        clouds: Int = 0,
        pop: Double = 0,
        uvi: Double = 0)
    {
        self.id = ObjectIdentifier(Daily.self)
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.moonrise = moonrise
        self.moonset = moonset
        self.moon_phase = moon_phase
        self.temp = temp
        self.feels_like = feels_like
        self.pressure = pressure
        self.humidity = humidity
        self.dew_point = dew_point
        self.wind_speed = wind_speed
        self.wind_deg = wind_deg
        self.wind_gust = wind_gust
        self.weather = weather
        self.clouds = clouds
        self.pop = pop
        self.uvi = uvi
    }
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
    
    private enum CodingKeys: String, CodingKey {
        case day = "day"
        case min = "min"
        case max = "max"
        case night = "night"
        case eve = "eve"
        case morn = "morn"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.day = try container.decode( Double.self, forKey: .day)
        self.min = try container.decode( Double.self, forKey: .min)
        self.max = try container.decode( Double.self, forKey: .max)
        self.night = try container.decode( Double.self, forKey: .night)
        self.eve = try container.decode( Double.self, forKey: .eve)
        self.morn = try container.decode( Double.self, forKey: .morn)
    }
    
    init(day: Double = 0.0,
         min: Double = 0.0,
         max: Double = 0.0,
         night: Double = 0.0,
         eve: Double = 0.0,
         morn: Double = 0.0) {
        self.day = day
        self.min = min
        self.max = max
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
    
    private enum CodingKeys: String, CodingKey {
        case day = "day"
        case night = "night"
        case eve = "eve"
        case morn = "morn"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.day = try container.decode(Double.self, forKey: .day)
        self.night = try container.decode(Double.self, forKey: .night)
        self.eve = try container.decode(Double.self, forKey: .eve)
        self.morn = try container.decode(Double.self, forKey: .morn)
    }
    
    init( day: Double = 0.0,
          night: Double = 0.0,
          eve: Double = 0.0,
          morn: Double = 0.0 ) {
        self.day = day
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}
