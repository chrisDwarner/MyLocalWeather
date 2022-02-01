//
//  TempMinMaxModel.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//

import Foundation
import PrettyAxis

struct TempMinMaxModel: Decodable {
    let month: String
    let value: Double
    let name: String    
}

extension TempMinMaxModel: Axisable{
    var x: String{
        return month
    }
    
    var y: Double{
        return value
    }
    
    var z: AnyHashable? { return nil}
    var groupd: AnyHashable? { return name}
}

struct TestChartData: Decodable{
    let label: String
    let value: Double
}

extension TestChartData: Axisable{
    var x: String{
        return label
    }
    
    var y: Double{
        return value
    }
    
    var z: AnyHashable? { return nil}
    var groupd: AnyHashable? { return nil}
}



