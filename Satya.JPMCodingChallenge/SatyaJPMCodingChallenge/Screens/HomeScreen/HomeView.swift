
import SwiftUI
import CoreLocation
import LocalAuthentication
import CoreLocationUI

struct HomeView: View {
    
    @ObservedObject var cityData: CityData
    @StateObject var locationDataManager = LocationDataManager()

    var body: some View {
        
        Group {
            // Check the cities count with the weather count
            if cityData.cities.count != cityData.allWeathers.count {
                // Loader View
                LoadingView()
            } else {
            // load the City list with the subscriber - receive data model
                CityList(temperatureData: TemperatureData(), cityData: cityData)
            }
        }
        
        VStack {
                // Location Services managed here and calls the Citydata functions to fetch the current city
               switch locationDataManager.locationManager.authorizationStatus {
               case .authorizedWhenInUse, .authorized, .authorizedAlways:  // Location services are available.
                   // Insert code here of what should happen when Location services are authorized
                   Text("Location enabled")
                       .onAppear(perform: cityData.locationFetch)
               default:
                   Text("Location disabled")
               }
           }
    }
}
