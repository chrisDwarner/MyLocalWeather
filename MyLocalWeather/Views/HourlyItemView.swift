//
//  HourlyItemView.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//


import Combine
import SwiftUI
import RealmSwift

struct HourlyItemView: View {
    
    @ObservedRealmObject var city: City
    
    @State var cityName: String = "CityName"
    @State var icon: UIImage =  UIImage(named: "LaunchScreen") ?? UIImage()
    @State var daylightHours: String = "sunrise xx:xx sunset: xx:xx"
    @State var currentCond: String = "Temp 000 dew: 000 uvi: 000 "
    
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
                        Text(daylightHours)
                    }
                }
                Text(currentCond).padding([ .trailing])
                    .foregroundColor(.primary)
            }
            .padding(6)
            .background(Color("LaunchScreenBackground", bundle: .main).edgesIgnoringSafeArea(.all))
        }
        .onAppear {
            cityName = city.name
            DownloadManager.shared.fetchOneCall(for: city) { (onCall, error) in
                if let data = onCall {
                    let current = data.current

                    if let iconString = current.weather.first?.icon {
                        DownloadManager.shared.fetchWeatherIcon(iconString) { self.icon = $0 }
                    }
                    
                    daylightHours = "sunrise \(current.sunrise.timeString) sunset: \(current.sunset.timeString)"
                    currentCond = "Temp \(current.temp.tempInF) dew: \(current.dew_point.tempInF) uvi: \(current.uvi)"
                }
            }
        }
    }
}

#if DEBUG
struct HourlyItemView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyItemView(city: City())
            .previewLayout(.sizeThatFits).clipped()
    }
}
#endif
