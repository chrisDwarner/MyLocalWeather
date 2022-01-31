//
//  Location.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/30/22.
//

import CoreLocation
import Foundation
import RealmSwift

final class Location: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId()
    @Persisted var lat: Double
    @Persisted var long: Double
    
    convenience init( lat: Double, lon: Double ) {
        self.init()
        self._id = ObjectId.generate()
        self.lat = lat
        self.long = lon
    }
    
    convenience init(loc coord: CLLocationCoordinate2D ) {
        self.init(lat: coord.latitude, lon: coord.longitude)
    }
}
