//
//  ContentView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import SwiftUI

struct ContentView: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CityListView: View {
    
    let cities = ["1","2","3","4","5"]
    // show 10 items
    @State var range: Range<Int> = 0..<5
    
    
    var body: some View {
        Divider()
        VStack(spacing: 0) {
            
            ForEach( range, id: \.self ) {
                Text("City List View \(cities[$0])").padding()
            }
        }
        Spacer()
    }
}
