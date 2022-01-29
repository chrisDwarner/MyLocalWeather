//
//  CityListNavView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import SwiftUI

/// the default city list view with a navigation view
struct CityListNavView: View {
    var body: some View {
        NavigationView {
            CityListView()
                .navigationBarTitle("MyLocalWeather", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    //TODO: - launch search modal view Google places
                }) {
                    Text("Add Cities")
                })
        }
    }
}

/// the list of Cities you are tracking
struct CityListView: View {
    
    let cities: [City] = [City(value: "1"), City(value: "2"), City(value: "3"), City(value: "4"), City(value: "5")]
    @State var range: Range<Int> = 0..<5
    
    
    var body: some View {
        Divider()
        VStack(spacing: 0) {
            
            ForEach( range, id: \.self ) {
                CityListItemView(city: cities[$0])
            }
        }
        Spacer()
    }
}


#if DEBUG
struct CityListNavView_Previews: PreviewProvider {
    static var previews: some View {
        CityListNavView()
    }
}
#endif
