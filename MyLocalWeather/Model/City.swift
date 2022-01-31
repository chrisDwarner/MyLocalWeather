//
//  City.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import CoreLocation
import Foundation
import RealmSwift

/// City is a Realm object that contains enough information to fetch the weather information
/// by city name or location
final class City: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId()
    @Persisted var name: String = "cityName"
    @Persisted var location: Location?
    
    @Persisted(originProperty: "cities") var group: LinkingObjects<Group>
    
    private var downloader = DownloadManager()
    @Published var oneCall: OneCall!
    

    convenience init( name: String, coord: CLLocationCoordinate2D ) {
        self.init()
        self._id = ObjectId.generate()
        self.name = name
        self.location = Location(loc: coord )
        downloader.fetchOneCall(for: self, block: hanldler )
    }
    
    func hanldler(_ oneCall: OneCall?, error: Error? ) {
        
        if let err = error {
            print(err)
            return
        }

        guard let weatherData = oneCall else { return }
        self.oneCall = weatherData
    }
}
