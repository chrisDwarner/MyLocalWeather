//
//  Date+extensions.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//

import Foundation

extension Date {

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    var dayOfWeek: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "eee"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }

}
