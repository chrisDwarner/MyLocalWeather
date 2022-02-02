//
//  ForecastDetailsView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import RealmSwift
import SwiftUI
import PrettyAxis


struct ForecastDetailsView: View {
    
    @ObservedRealmObject var city: City
    
    @State var tempMinMax: [TempMinMaxModel] = []
    @State var hourlyReadings: [HourlyModel] = []
    @State var icon: UIImage =  UIImage(named: "LaunchScreen") ?? UIImage()
    @State var temp: String = "Temp"
    @State var feelsLike: String = "feels like"
    @State var currentConditions: String = "Current Conditions"
    @State var windInfo: String = "00.0m/s N"

    var body: some View {
        let bg = RoundedRectangle(cornerRadius: 15).foregroundColor(Color(white: 0.9))
        ScrollView {
            VStack {
                Text(city.name).font(.title).bold()
                Current
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                Divider()
                Text("Daily Min Max temps")
                dailyMinMax.frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(bg)
                    .padding(.horizontal)
                Divider()
                Text("Hourly Observations")
                hourlyObservations.frame(height: 130)
                .frame(maxWidth: .infinity)
                .background(bg)
                .padding(.horizontal)
            }
            .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .local).onEnded({ value in
                if value.translation.height > 0 {
                    // swipe down detected, refresh the view
                    refresh()
                }
            }))
        }
        .onAppear(perform: {
            refresh()
        })
    }
    
    // with swiftUI there is a hard limit on the number of elements in the main body.
    // When you exceed that, SwiftUI and XCode go full on weird
    // to get around that, and to help execution times, break down the UI elements in to
    // smaller building blocks with sub-views using @ViewBuilder
    @ViewBuilder
    var Current: some View {
        Divider()
        Text(currentConditions).font(.headline)
        HStack {
            Image(uiImage: icon).resizable()
                .scaledToFill().frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text(temp).font(.caption)
                Text(feelsLike).font(.caption)
            }
        }
        Text(windInfo).font(.caption2)
    }
    
    // Daily min max temp chart view
    @ViewBuilder
    var dailyMinMax: some View {
        
        let stroke = ["Min Temp": LinearGradient.minTempStroke, "Max Temp": LinearGradient.maxTempStroke]
        let fill = ["Min Temp": LinearGradient.minTempFill, "Max Temp": LinearGradient.maxTempFill]
        
        if !tempMinMax.isEmpty {
            
            AxisView(style: .line, data: tempMinMax)
                .stroke(stroke)
                .fill(fill)
                .labelColor(Color.houlyFontColor)
                .referenceLine(style: ReferenceLineStyle(axisColor: Color.gray))
                .spacing(40)
                .enableLegend(true, style: LegendStyle(labelColor: Color.houlyFontColor))
                .fromZero(false)
                .padding()
        }
    }
    
    // hourly observations view
    @ViewBuilder
    var hourlyObservations: some View {
        let bg = RoundedRectangle(cornerRadius: 15).foregroundColor(Color(white: 0.9))
        ScrollView (.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(hourlyReadings, id: \.id) { hourly in
                    HourlyObservationView(hourly: hourly )
                }
            }
            .background(bg)
        }
    }
    
    func refresh() {
        DownloadManager.shared.fetchOneCall(for: city) { (onCall, error) in
            if let data = onCall {
                let dataset = data.dailyTempChartData
                self.tempMinMax = dataset
                let readings  = data.hourlyObservations
                self.hourlyReadings = readings
                self.temp = "Temp: \(data.current.temp.tempInF)"
                self.feelsLike = "Feels Like:\(data.current.feels_like.tempInF)"
                
                let dt = Date(timeIntervalSince1970: data.current.dt.timeIntervalValue )
                let formatter = DateFormatter()
                
                formatter.dateFormat = "MMM d"

                let dateStr = formatter.string(from: dt)

                self.currentConditions = "Current Conditions - \(dateStr), \(data.current.dt.timeString)"
                
                if let iconString = data.current.weather.first?.icon {
                    DownloadManager.shared.fetchWeatherIcon(iconString) { self.icon = $0 }
                }

                let compassDir = data.current.compassHeading
                self.windInfo = "Wind speed: \(data.current.wind_speed)m/s \(compassDir) Dew point: \(data.current.dew_point.tempInF)"
            }
        }
    }
}

#if DEBUG
struct ForecastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailsView(city: City(value: "dreams"))
    }
}
#endif
