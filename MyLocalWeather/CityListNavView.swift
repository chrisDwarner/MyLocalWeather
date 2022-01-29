//
//  CityListNavView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import RealmSwift
import SwiftUI

/// the default city list view with a navigation view
struct CityListNavView: View {
    
    @ObservedResults(Group.self) var cityList
    
    var body: some View {
        NavigationView {
            if let cities = cityList.first {
                CityListView(cityList: cities)
                    .navigationBarTitle("MyLocalWeather", displayMode: .inline)
                    .navigationBarItems(leading: EditButton(), trailing: Button(action: buttonAction ) {
                        Image(systemName: "plus")
                    })
            }
            else {
                ProgressView().onAppear {
                    $cityList.append(Group())
                }
            }
        }
    }
    
    func buttonAction() {
        //TODO:- launch Google Places search view controller.
    }
}

/// the list of Cities you are tracking
struct CityListView: View {
    
    @ObservedRealmObject var cityList: Group

    var body: some View {
        Divider()
        VStack(spacing: 0) {
            ForEach( cityList.cities ) {
                CityListItemView(city: $0 )
            }.onDelete(perform: $cityList.cities.remove )
                .onMove(perform: $cityList.cities.move )
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
