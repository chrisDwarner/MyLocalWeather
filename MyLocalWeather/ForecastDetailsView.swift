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
    @State var minDailyTempDataSet: [TestChartData] = []
    @State var maxDailyTempDataSet: [TestChartData] = []

    var body: some View {
        let bg = RoundedRectangle(cornerRadius: 15).foregroundColor(Color(white: 0.9))

        VStack {
            Text("City of \(city.name)")
            if !tempMinMax.isEmpty {
                line.frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(bg)
                    .padding(.horizontal)
            }
        }
        .onAppear(perform: {
            DownloadManager.shared.fetchOneCall(for: city) { (onCall, error) in
                if let data = onCall {
                    let dataset = data.dailyTempChartData
                    self.tempMinMax = dataset
                    self.minDailyTempDataSet = data.minDailyTempChart
                    self.maxDailyTempDataSet = data.maxDailyTempChart
                }
            }
        })
    }

    @ViewBuilder
    var line: some View {
        let stroke = ["Min Temp": g5, "Max Temp": g6]
        let fill = ["Min Temp": g1, "Max Temp": g2]
        
        AxisView(style: .line, data: tempMinMax)
//            .stroke(LinearGradient(colors: [Color.blue, Color.green], startPoint: .top, endPoint: .bottom))
//            .fill(g5)
            .stroke(stroke)
            .fill(fill)
            .labelColor(Color.black)
            .referenceLine(style: ReferenceLineStyle(axisColor: Color.yellow))
            .spacing(40)
            .enableLegend(true, style: LegendStyle(labelColor: Color.gray))
            .fromZero(false)
            .padding()
    }
    
    @ViewBuilder
    var bar: some View {
        AxisView(style: .bar, data: minDailyTempDataSet)
            .fill(g5)
            .fromZero(false)
            .labelColor(Color.yellow)
            .referenceLine(style: ReferenceLineStyle(axisColor: Color.yellow))
            .spacing(20)
            .enableLegend(true, style: LegendStyle(labelColor: Color.white))
            .sortXAxis(by: {$0 < $1})
            .padding()
    }
    

}




#if DEBUG
struct ForecastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailsView(city: City(value: "dreams"))
    }
}
#endif


let colors1 = [Color(hue: 14 / 360.0, saturation: 0.88, brightness: 0.99),
               Color(hue: 40 / 360.0, saturation: 0.79, brightness: 0.97)]
let colors2 = [Color(hue: 191 / 360.0, saturation: 0.91, brightness: 0.92),
               Color(hue: 280 / 360.0, saturation: 0.52, brightness: 0.93),
               Color(hue: 356 / 360.0, saturation: 0.68, brightness: 0.96)]

let colors3 = [Color(hue: 145 / 360.0, saturation: 0.22, brightness: 0.9),
               Color(hue: 41 / 360.0, saturation: 0.46, brightness: 0.98),
               Color(hue: 358 / 360.0, saturation: 0.51, brightness: 0.97)]

let colors4 = [Color(hue: 308 / 360.0, saturation: 0.23, brightness: 0.77),
               Color(hue: 51 / 360.0, saturation: 0.16, brightness: 0.85),
               Color(hue: 217 / 360.0, saturation: 0.37, brightness: 0.81)]

let colors5 = [
    Color(hue:  2 / 360, saturation: 0.28, brightness: 0.95),
    Color(hue:  35 / 360, saturation: 0.31, brightness: 0.97),
    Color(hue:  187 / 360, saturation: 0.30, brightness: 0.99),
    Color(hue:  220 / 360, saturation: 0.33, brightness: 0.98),
    Color(hue:  247 / 360, saturation: 0.28, brightness: 0.99),
    Color(hue:  293 / 360, saturation: 0.20, brightness: 0.99),
]


let g1 = LinearGradient(colors: colors1.map({$0.opacity(0.5)}), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
let g2 = LinearGradient(colors:  colors2.map({$0.opacity(0.5)}), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
let g3 = LinearGradient(colors:  colors3.map({$0.opacity(0.5)}), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
let g4 = LinearGradient(colors:  colors4.map({$0.opacity(0.5)}), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
let g5 = LinearGradient(colors: colors1, startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
let g6 = LinearGradient(colors:  colors2, startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))

