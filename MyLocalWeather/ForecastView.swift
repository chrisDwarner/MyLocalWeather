//
//  ForecastView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/31/22.
//

import RealmSwift
import SwiftUI

struct ForecastView: View {

    // observe all the groups (add, current, hourly)
    @ObservedResults(Group.self) var groupList

    // if you see the underscores, something has gone wrong
    @State var currentGroup = Group(name: "_Current_")
    @State var hourlyGroup = Group(name: "_Hourly_")
    @State var selection = 1
    
    var body: some View {
        if !groupList.isEmpty {
            TabView(selection: $selection) {
                CityListNavView(group: currentGroup).tabItem { Label(currentGroup.name, systemImage: "list.dash") }.tag(1)
                CityListNavView(group: hourlyGroup).tabItem { Label(hourlyGroup.name, systemImage: "clock") }.tag(2)
            }
            .onAppear(perform: {
                currentGroup = groupList.first!
                hourlyGroup = groupList.last!
            })
        }
        else {
            ProgressView().onAppear {
                $groupList.append(Group())
            }
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}


struct CurrentView: View {
    @State private var showAddCityAlert = false
    
    var body: some View {
        Text("current view")
    }
}

struct HourlyView: View {
    @State private var showAddCityAlert = false
    
    var body: some View {
        Text("hourly view")
    }
}
