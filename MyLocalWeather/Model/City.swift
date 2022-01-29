//
//  City.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import Foundation
import RealmSwift

class City: Object {
    @Persisted var name: String
}
