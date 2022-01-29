//
//  City.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import Foundation
import RealmSwift

/// City is a Realm object that contains enough information to fetch the weather information
/// by city name or location
final class City: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    
    @Persisted(originProperty: "cities") var group: LinkingObjects<Group>
}
