//
//  Group.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import Foundation
import RealmSwift

/// The Group object is a realm object that contains a list of City objects.
///  Groups can be used for organizing city forecasts in collections (i.e favorites, etc..)
final class Group: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = "all"

    @Persisted var cities = RealmSwift.List<City>()
}
