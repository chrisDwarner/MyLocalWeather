//
//  CityListItemView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import SwiftUI

struct CityListItemView: View {
    var city: City
    
    var body: some View {
        Text("City of \(city.name)")
    }
}

struct CityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CityListItemView(city: City(name: "Santa Cruz"))
    }
}

struct City: Identifiable {
    let id = UUID()
    
    let name: String
}
