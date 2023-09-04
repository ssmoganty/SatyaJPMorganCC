
import SwiftUI

struct PageView: View {
    
    var temperatureData: TemperatureData
    var allWeathers: [AllWeather]
    var viewControllers: [UIHostingController<WeatherCityView>]
    var firstIndex: Int
    
    @State var currentPage: Int = 0

    init(temperatureData: TemperatureData, allWeathers: [AllWeather], currentPage: Int) {
        let weatherCityViews = allWeathers.map { WeatherCityView(temperatureData: temperatureData, allWeather: $0) }
        self.viewControllers = weatherCityViews.map { UIHostingController(rootView: $0) }
        self.temperatureData = temperatureData
        self.allWeathers = allWeathers
        self.firstIndex = currentPage
    }

    var body: some View {
        VStack(spacing: -4) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
            
            ZStack {
                BottomBar()
                PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
                    .padding(.bottom, -10.0)
            }
        }.onAppear(perform: { self.currentPage = self.firstIndex })
    }
}
