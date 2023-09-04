
import Combine
import MapKit

// cityData object notify views when there's a change in the data from the API response.

class CityData: ObservableObject {
    
    let locationManager: CLLocationManager
    var locationDataManager = LocationDataManager()
    var cities = [String]()
    
    @Published var allWeathers = [AllWeather]()
    
    init() {
        
        locationManager = CLLocationManager()
        unarchiveCities()
        locationManager.requestWhenInUseAuthorization()

    }
    
    func addCity(_ city: String) {
        cities.removeAll()
        cities.append(city)
        archiveCities()
        locationFetch()
        
    }
    
    func locationFetch() {
        if CLLocationManager.locationServicesEnabled(), let location = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let currentCity = placemarks?.first?.locality, !self.cities.contains(currentCity) {
                    self.cities.insert(currentCity, at: 0)
                }
                self.fetch()
            }
        } else {
            fetch()
        }
    }
    
    func fetch() {
        
        allWeathers.removeAll()
        
        cities.forEach { city in
            let weatherCityData = WeatherCityData(city: city)
           
            weatherCityData.fetch() {
                var tmpWeathers = [AllWeather]()
                if weatherCityData.weatherDetail == nil {
                    self.allWeathers.removeAll()
                    self.cities.removeAll()
                    self.unarchiveCities()
                    return }
                tmpWeathers.append(AllWeather(weatherDetail: weatherCityData.weatherDetail!,
                                              weatherHourlyForecast: weatherCityData.weatherHourlyForecast!,
                                              weatherDailyForecast: weatherCityData.weatherDailyForecast!))
                
                tmpWeathers.forEach({ allWeather in
                    if let index = self.cities.firstIndex(of: allWeather.weatherDetail.name),
                       index <= self.allWeathers.count {
                        self.allWeathers.insert(allWeather, at: index)
                    } else {
                        self.allWeathers.append(allWeather)
                    }
                })
            }
        }
    }
    
    private func unarchiveCities() {
        do {
            if let citiesData = UserDefaults.standard.data(forKey: "cities"),
               let cities = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(citiesData) as? [String] {
                self.cities = cities
            }
        } catch {
#if DEBUG
            print("Cannot unarchive cities data")
#endif
        }
    }
    
    private func archiveCities() {
        do {
            let encodedCities = try NSKeyedArchiver.archivedData(withRootObject: cities, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedCities, forKey: "cities")
            UserDefaults.standard.synchronize()
        } catch {
#if DEBUG
            print("Cannot archive cities data")
#endif
        }
    }
}
