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
    
    @State var cityName: String = "CityName"
    @State var icon: Image = Image("LaunchScreen", bundle: .main)
    @State var tempHumidity: String = "temp xxx Humidity: xx%"
    @State var feelsLike: String = "Feels like xxx. clear sky. Light breeze "
    
    var body: some View {
        NavigationLink(destination: ForecastDetailsView(city: city)) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack {
                        Image("LaunchScreen", bundle: .main).resizable()
                            .scaledToFill().frame(width: 48, height: 48)

                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(cityName)
                            .bold()
                            .foregroundColor(.white)
                        Text(tempHumidity)
                    }
                }
                Text(feelsLike).padding([ .trailing])
                    .foregroundColor(.primary)
            }
            .padding(6)
            .background(Color("LaunchScreenBackground", bundle: .main).edgesIgnoringSafeArea(.all))
        }
    }
}

struct CityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CityListItemView(city: City())
            .previewLayout(.sizeThatFits).clipped()
    }
}
