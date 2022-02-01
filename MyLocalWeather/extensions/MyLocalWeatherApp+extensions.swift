//
//  MyLocalWeatherApp+extensions.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//

import Foundation
import RealmSwift

extension MyLocalWeatherApp {

    // this method cannot be in the same location as the main app
    // Realm in their infinite wisdom used 'App' as an internal realm construct which
    //  messes with SwiftUI's version of 'App'.  How cool is that?
    func initDatabase() {
        do {
            let realm = try Realm()
            
            let groups = realm.objects(Group.self)
            if groups.isEmpty {
                realm.beginWrite()
                realm.add(Group(name: "Current"), update: .all)
                realm.add(Group(name: "Hourly"), update: .all)
                
                try realm.commitWrite()
            }
        }
        catch {
            print( error )
        }

    }
    
    //TODO: - add methods for realm db migration here
}
