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
            }
            else {
                ProgressView().onAppear {
                    $cityList.append(Group())
                }
            }
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
                    CityListItemView(city: $0 )
                        .background(Color("LaunchScreenBackground", bundle: .main).edgesIgnoringSafeArea(.all))
                        .cornerRadius(6)
                        .clipped()
                    .listRowSeparator(.hidden)                }
                .onDelete(perform: $cityList.cities.remove )
                .onMove(perform: $cityList.cities.move )
            }
            .navigationBarTitle("MyLocalWeather", displayMode: .inline)
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
        CityListNavView()
    }
}
#endif
