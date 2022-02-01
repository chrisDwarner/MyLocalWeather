//
//  ForecastDetailsView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import RealmSwift
import SwiftUI

struct ForecastDetailsView: View {
    @ObservedRealmObject var city: City

    var body: some View {
        Text("City of \(city.name)")

    }
}

#if DEBUG
struct ForecastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailsView(city: City(value: "dreams"))
    }
}
#endif
