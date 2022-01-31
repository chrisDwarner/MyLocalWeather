//
//  Double+extension.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/31/22.
//

import Foundation

extension Double {
    var kelvinInC: Double {
        return -273.15 + self
    }
    
    var kelvinInF: Double {
        return ((-273.15 + self) * 1.8 ) + 32
    }
    
    var tempInF: String {
        return String( format: "%.0f", self.kelvinInF)
    }
    
    var tempInC: String {
        return String( format: "%.0f", self.kelvinInC)
    }
}
