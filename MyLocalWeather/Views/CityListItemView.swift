//
//  CityListItemView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import SwiftUI
import RealmSwift

struct CityListItemView: View {
    
    @ObservedRealmObject var city: City
    
    var body: some View {
        NavigationLink(destination: ForecastDetailsView(city: city)) {
            Text("City of \(city.name)")
        }
    }
}

struct CityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CityListItemView(city: City(value: "Santa Cruz"))
    }
}
