//
//  TempChartData.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//

import Foundation
import PrettyAxis

struct TempChartData: Decodable{
    let label: String
    let value: Double
}

extension TempChartData: Axisable{
    var x: String{
        return label
    }
    
    var y: Double{
        return value
    }
    
    var z: AnyHashable? { return nil}
    var groupd: AnyHashable? { return nil}
}



