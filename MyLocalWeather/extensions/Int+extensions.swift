//
//  Int+extensions.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//

import Foundation


extension Int {
    
    var timeIntervalValue: TimeInterval {
        // return only val
        return TimeInterval(self)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        
        if !timeIntervalValue.isInfinite && !timeIntervalValue.isNaN {
            let date = Date(timeIntervalSince1970: timeIntervalValue)// .toLocalTime()
            
            formatter.dateFormat = "h:mm"
            formatter.timeStyle = .short
            let string = formatter.string(from: date)
            return string
        }
        return ""
    }
}
