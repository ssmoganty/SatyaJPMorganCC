
import Combine
import SwiftUI


// WeatherCityData object notify views when there's a change in the data from the API response.

class WeatherCityData: ObservableObject {
    
    @Published var weatherDetail: WeatherDetail? = nil
    @Published var weatherDailyForecast: WeatherForecast? = nil
    @Published var weatherHourlyForecast: WeatherForecast? = nil
    @Published var allWeathers = [AllWeather]()

    let city: String
    
    init(city: String) {
        self.city = city
        
    }
    
    /* Fetching the array of cities from the CityData model
        Response will be in the completion Handler - Result WeatherDetail object
        If error throws - handled in the result switch case
        On Success - adding the result object into the WeatherForecastDetail model
    */
    
    func fetch(completion: @escaping () -> Void) {
        APIService.shared.GET(endpoint: .weather, params: ["q": city]) { (result: Result<WeatherDetail, APIService.APIError>) in
            switch result {
            case .success(_):
                if let weatherDetail = try? result.get() {
                    self.weatherDetail = weatherDetail
                    if self.weatherDetail == nil{
                        self.allWeathers.removeAll()
                        self.weatherDetail?.weather.removeAll()
                        return
                    }
                    if var weatherHourlyForecast = self.weatherHourlyForecast {
                        weatherHourlyForecast.list.insert(
                            WeatherForecastDetail(dt: weatherDetail.dt,
                                                  dt_txt: "",
                                                  clouds: weatherDetail.clouds,
                                                  wind: weatherDetail.wind,
                                                  weather: weatherDetail.weather,
                                                  rain: nil,
                                                  main: WeatherForecastDetail.Main(temp: weatherDetail.main.temp,
                                                                                   temp_min: weatherDetail.main.temp_min,
                                                                                   temp_max: weatherDetail.main.temp_max,
                                                                                   pressure: Float(weatherDetail.main.pressure),
                                                                                   sea_level: 0.0,
                                                                                   grnd_level: 0.0,
                                                                                   humidity: weatherDetail.main.humidity,
                                                                                   temp_kf: 0.0)),
                            at: 0)
                    }
                    
                    if self.weatherHourlyForecast != nil, self.weatherDailyForecast != nil {
                        completion()
                    }
                }
            case .failure(_):
                self.allWeathers.removeAll()
                self.weatherDetail?.weather.removeAll()
                completion()
            }
        }
        
        APIService.shared.GET(endpoint: .dailyForecast, params: ["q": city]) { (result: Result<WeatherForecast, APIService.APIError>) in
            switch result {
            case .success(_):
                if var weatherForecast = try? result.get() {
                    var i = -1
                    var tmpDailyForecast = [WeatherForecastDetail]()

                    for weatherForecast in weatherForecast.list {
                        if weatherForecast.date.dayOfTheWeek == Date().dayOfTheWeek {
                            continue
                        } else if tmpDailyForecast.contains(weatherForecast) {
                            tmpDailyForecast[i].main.temp_min = min(tmpDailyForecast[i].main.temp_min,
                                                                    weatherForecast.main.temp_min)
                            tmpDailyForecast[i].main.temp_max = max(tmpDailyForecast[i].main.temp_max,
                                                                    weatherForecast.main.temp_max)
                        } else {
                            tmpDailyForecast.append(weatherForecast)
                            i += 1
                        }
                    }

                    self.weatherDailyForecast = weatherForecast
                    self.weatherDailyForecast?.list = tmpDailyForecast
                    
                    if let weatherDetail = self.weatherDetail {
                        weatherForecast.list.insert(
                            WeatherForecastDetail(dt: weatherDetail.dt,
                                                  dt_txt: "",
                                                  clouds: weatherDetail.clouds,
                                                  wind: weatherDetail.wind,
                                                  weather: weatherDetail.weather,
                                                  rain: nil,
                                                  main: WeatherForecastDetail.Main(temp: weatherDetail.main.temp,
                                                                                   temp_min: weatherDetail.main.temp_min,
                                                                                   temp_max: weatherDetail.main.temp_max,
                                                                                   pressure: Float(weatherDetail.main.pressure),
                                                                                   sea_level: 0.0,
                                                                                   grnd_level: 0.0,
                                                                                   humidity: weatherDetail.main.humidity,
                                                                                   temp_kf: 0.0)),
                            at: 0)
                    }
                    
                    self.weatherHourlyForecast = weatherForecast
                    
                    if self.weatherDetail != nil {
                        completion()
                    }
                }
            case .failure(_):
                self.allWeathers.removeAll()
                self.weatherDetail?.weather.removeAll()
                completion()
            }
        }
    }
}
