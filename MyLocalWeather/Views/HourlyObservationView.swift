//
//  HourlyObservationView.swift
//  MyLocalWeather
//
//  Created by chris warner on 2/1/22.
//

import SwiftUI

struct HourlyObservationView: View {
    @State var hourly:HourlyModel
    @State var icon: UIImage =  UIImage(named: "LaunchScreen") ?? UIImage()
    @State var timeStamp: String = "Time Stamp"
    @State var temp: String = "Temp"
    @State var visiblity: String = "Time Stamp"
    
    var body: some View {
        VStack {
            Text(timeStamp).font(.caption)
                .foregroundColor(Color.houlyFontColor)
            Divider()
            HStack {
                Image(uiImage: icon).resizable()
                    .scaledToFill().frame(width: 48, height: 48)
                Text(temp).font(.footnote)
                    .foregroundColor(Color.houlyFontColor)
            }
            Divider()
            Text(visiblity).font(.caption2)
                .foregroundColor(Color.houlyFontColor)
        }
        .onAppear {
            self.timeStamp = hourly.timeStamp
            self.temp = "\(hourly.temp)"
            self.visiblity = "\(hourly.pressure)hPa \(hourly.humidity)%"
            DownloadManager.shared.fetchWeatherIcon(hourly.icon) { icon = $0 }
        }
        .frame(width: 100)
    }
}

#if DEBUG
struct HourlyObservationView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyObservationView(hourly: HourlyModel())
            .previewLayout(.sizeThatFits)
    }
}
#endif

