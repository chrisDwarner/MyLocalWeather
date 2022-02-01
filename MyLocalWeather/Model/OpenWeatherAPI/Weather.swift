//
//  Weather.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/31/22.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
    
    init( id: Int = 0,
          main: String = "",
          description: String = "",
          icon: String = "") {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self )
        
        self.id = try container.decode( Int.self, forKey: .id)
        self.main = try container.decode( String.self, forKey: .main)
        self.description = try container.decode( String.self, forKey: .description)
        self.icon = try container.decode( String.self, forKey: .icon)
    }    
}
