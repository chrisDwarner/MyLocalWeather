//
//  CityListItemView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import Combine
import SwiftUI
import RealmSwift

struct CityListItemView: View {
    
    @ObservedRealmObject var city: City
    
    @State var cityName: String = "CityName"
    @State var icon: UIImage =  UIImage(named: "LaunchScreen") ?? UIImage()
    @State var tempHumidity: String = "temp xxx Humidity: xx%"
    @State var feelsLike: String = "Feels like xxx. clear sky. Light breeze "
    
    var body: some View {
        NavigationLink(destination: ForecastDetailsView(city: city)) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    VStack {
                        Image(uiImage: icon).resizable()
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
        .onAppear {
            cityName = city.name
            DownloadManager.shared.fetchOneCall(for: city) { (onCall, error) in
                if let data = onCall {
                    if let weather = data.weather.first {
                        let feelsLike = data.main.feelsLike.tempInF
                        let desc = "Feels like \(feelsLike). \(weather.main). \(weather.description)"
                        self.feelsLike = desc
                    }
                    let temp = data.main.temp.tempInF
                    let subtitle = "temp \(temp) Humidity: \( data.main.humidity )%"
                    self.tempHumidity = subtitle
                    
                    if let iconString = data.weather.first?.icon {
                        DownloadManager.shared.fetchWeatherIcon(iconString) { self.icon = $0 }
                    }
                }
            }
        }
    }
}

struct CityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CityListItemView(city: City())
            .previewLayout(.sizeThatFits).clipped()
    }
}
