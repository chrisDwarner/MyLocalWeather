//
//  MyLocalWeatherApp.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import SwiftUI

@main
struct MyLocalWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            CityListNavView()
        }
    }
    
    /// initialize the application.
    init() {
        // setup the openWeatherApi key
    }
}
