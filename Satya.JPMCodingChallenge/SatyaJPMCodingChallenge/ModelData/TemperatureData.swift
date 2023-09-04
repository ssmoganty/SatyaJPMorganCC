
import Combine

class TemperatureData: ObservableObject {
    
    @Published var temperatureUnit = 0
    
    func temperature(_ kelvinValue: Kelvin) -> Int {
        switch temperatureUnit {
        case 0:
            return kelvinValue.celsiusValue
        default:
            return kelvinValue.fahrenheitValue
        }
    }
}
