//
//  ForecastDetailsView.swift
//  MyLocalWeather
//
//  Created by chris warner on 1/28/22.
//

import RealmSwift
import SwiftUI
import PrettyAxis


let colors1 = [Color(hue: 14 / 360.0, saturation: 0.88, brightness: 0.99),Color(hue: 40 / 360.0, saturation: 0.79, brightness: 0.97)]
let tempRange: [Color] = [.red, .green, .black]
let minTempFill = LinearGradient(colors: tempRange.map({$0.opacity(0.8)}), startPoint: .top, endPoint: .bottom)
let maxTempFill = LinearGradient(colors:  tempRange.map({$0.opacity(0.6)}), startPoint: .top, endPoint: .bottom)
let minTempStroke = LinearGradient(colors: colors1, startPoint: .top, endPoint: .bottom)
let maxTempStroke = LinearGradient(colors:  tempRange, startPoint: .top, endPoint: .bottom)

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
                // down
                refresh()
            }
        }))
        .onAppear(perform: {
            refresh()
        })
    }
    
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
    
    @ViewBuilder
    var dailyMinMax: some View {
        
        let stroke = ["Min Temp": minTempStroke, "Max Temp": maxTempStroke]
        let fill = ["Min Temp": minTempFill, "Max Temp": maxTempFill]
        
        if !tempMinMax.isEmpty {
            
            AxisView(style: .line, data: tempMinMax)
                .stroke(stroke)
                .fill(fill)
                .labelColor(Color.black)
                .referenceLine(style: ReferenceLineStyle(axisColor: Color.gray))
                .spacing(40)
                .enableLegend(true, style: LegendStyle(labelColor: Color.gray))
                .fromZero(false)
                .padding()
        }
    }
    
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

                let compassHeading = ["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"]
                let index = Int((Double(data.current.wind_deg) / 360.0) / 22.5) + 1
                let compassDir = compassHeading[index]
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
