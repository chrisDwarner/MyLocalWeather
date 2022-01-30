//
//  MyLocalWeatherApp.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import SwiftUI
import GooglePlaces

@main
struct MyLocalWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            CityListNavView()
        }
    }
    
    /// initialize the application.
    init() {
        
        // setup google places
        GMSPlacesClient.provideAPIKey("AIzaSyDGATUosEFYd5bN4Ul4Zhaz_TAKZ8bCY90")
        
        // setup the openWeatherApi key
        
    }
}
