
import SwiftUI

struct WeatherHourlyForecastList: View {
    
    var temperatureData: TemperatureData
    var weatherHourlyForecastList: [WeatherForecastDetail]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0.0) {
                ForEach(weatherHourlyForecastList) { weatherHourlyForecast in
                    WeatherHourlyForecastDetailView(temperatureData: self.temperatureData,
                                                    weatherHourlyForecast: weatherHourlyForecast)
                }
            }.frame(height: 110.0)
        }
    }
}
