
import MapKit
import SwiftUI

struct CityList: View {
    
    @ObservedObject var temperatureData: TemperatureData
    @ObservedObject var cityData: CityData
    
    @State var showNewCityModal = false
    
    var degrees = ["°C", "°F"]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if(cityData.allWeathers.count > 0) {
                        ForEach(0 ..< cityData.allWeathers.count) { index in
                            NavigationLink(destination: PageView(temperatureData: self.temperatureData,
                                                                 allWeathers: self.cityData.allWeathers,
                                                                 currentPage: index)) {
                                
                                // Load the TableViewCell data with the cityData Objects
                                CityCell(temperatureData: self.temperatureData,
                                         allWeather: self.cityData.allWeathers[index],
                                         isCurrentLocation: CLLocationManager.locationServicesEnabled() && index == 0)
                            }
                        }
                    }
                    HStack {
                        // Picker View to select Celsius and Farenheit
                        
                        Picker("Degree choice", selection: $temperatureData.temperatureUnit) {
                            ForEach(0 ..< degrees.count) { index in
                                Text(self.degrees[index])
                                    .tag(index)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                    }
                    
                    
                    HStack {
                        
                        Text("Add City")
                        Spacer()
                        Button(action: {
                            self.showNewCityModal = true
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.primary)
                        }
                    }
                }
                .navigationBarTitle(Text("Cities"))
            }
            
        }
        .sheet(isPresented: $showNewCityModal, content: { NewCityModal(cityData: self.cityData) })
    }
}
