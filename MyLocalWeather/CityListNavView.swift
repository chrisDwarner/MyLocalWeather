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
    @ObservedRealmObject var group: Group

    var body: some View {
        NavigationView {
            CityListView(cityList: group)
        }
    }
}

/// the list of Cities you are tracking
struct CityListView: View {
    
    @ObservedRealmObject var cityList: Group
    @State private var showAddCityAlert = false

    var body: some View {
        Divider()
        VStack(spacing: 0) {
            List {
                ForEach( cityList.cities ) {
                    
                    if cityList.name == "Current" {
                        CurrentItemView(city: $0 )
                            .background(Color("LaunchScreenBackground", bundle: .main).edgesIgnoringSafeArea(.all))
                            .cornerRadius(6)
                            .clipped()
                            .listRowSeparator(.hidden)
                    }else if cityList.name == "Hourly" {
                        HourlyItemView(city: $0 )
                            .background(Color("LaunchScreenBackground", bundle: .main).edgesIgnoringSafeArea(.all))
                            .cornerRadius(6)
                            .clipped()
                            .listRowSeparator(.hidden)
                    }
               }
                .onDelete(perform: $cityList.cities.remove )
                .onMove(perform: $cityList.cities.move )
            }
            .navigationBarTitle(cityList.name, displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                showAddCityAlert.toggle()
            }) {
                Image(systemName: "plus")
            }.sheet(isPresented: $showAddCityAlert) {
                AddPlacesView(group: cityList)
            })
        }
        Spacer()
    }
}

#if DEBUG
struct CityListNavView_Previews: PreviewProvider {
    static var previews: some View {
        CityListNavView(group: Group())
    }
}
#endif
