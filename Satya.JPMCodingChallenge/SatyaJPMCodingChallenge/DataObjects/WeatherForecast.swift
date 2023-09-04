
import Foundation
import SwiftUI

struct WeatherForecast: Codable, Identifiable {
    
    let id = UUID()
    
    var list: [WeatherForecastDetail]
}
