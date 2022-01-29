//
//  City.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import Foundation
import RealmSwift

final class City: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    
    @Persisted(originProperty: "cities") var group: LinkingObjects<Group>
}

final class Group: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = "all"

    @Persisted var cities = RealmSwift.List<City>()
}
