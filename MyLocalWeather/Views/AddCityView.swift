//
//  AddCityView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import RealmSwift
import SwiftUI

struct AddCityView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedRealmObject var group: Group
    @State private var name: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter City and State ")
            TextField("New City, CA", text: $name )
                .padding(6)
                .navigationBarTitle(name)
                .border(.secondary, width: 2)
                .cornerRadius(4)
            HStack {
                Spacer()
                Button(action: {
                    $group.cities.append(City(name: name))
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "plus")
                }
            }
        }.padding()
        
    }
}

//#if DEBUG
//struct AddCityView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCityView()
//    }
//}
//#endif

