//
//  HourlyModel.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//

import Foundation
import SwiftUI

struct HourlyModel: Decodable, Identifiable {
    var id: UUID = UUID()
    let icon: String
    let timeStamp: String
    let temp: String
    let visiblity: String
    let pressure: String
    let humidity: String
    
    private enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case timeStamp = "timeStamp"
        case temp = "temp"
        case visiblity = "visiblity"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    init(from decoder: Decoder) throws {
        self.id = UUID()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.icon = try container.decode(String.self, forKey: .icon)
        self.timeStamp = try container.decode(String.self, forKey: .timeStamp)
        self.temp = try container.decode(String.self, forKey: .temp)
        self.visiblity = try container.decode(String.self, forKey: .visiblity)
        self.pressure = try container.decode(String.self, forKey: .pressure)
        self.humidity = try container.decode(String.self, forKey: .humidity)
    }

    init(icon: String = "",
         timeStamp: String = "",
         temp: String = "",
         visiblity: String = "",
         pressure: String = "",
         humidity: String = "") {
        self.id = UUID()

        self.icon = icon
        self.timeStamp = timeStamp
        self.temp = temp
        self.visiblity = visiblity
        self.pressure = pressure
        self.humidity = humidity
    }
    
}


