//
//  LinearGradient+extensions.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/2/22.
//

import Foundation
import SwiftUI


extension LinearGradient {
    
    fileprivate static var tempRange: [Color] = [.red, .minStrokeColor, .black]
    fileprivate static var minTempRangeStroke: [Color] = [.minStrokeColor, .minStrokeColor, .minStrokeColor]
    
    static var minTempFill = LinearGradient(colors: tempRange.map({$0.opacity(0.8)}), startPoint: .top, endPoint: .bottom)
    static var maxTempFill = LinearGradient(colors:  tempRange.map({$0.opacity(0.6)}), startPoint: .top, endPoint: .bottom)
    static var minTempStroke = LinearGradient(colors: minTempRangeStroke, startPoint: .top, endPoint: .bottom)
    static var maxTempStroke = LinearGradient(colors:  tempRange, startPoint: .top, endPoint: .bottom)
}
