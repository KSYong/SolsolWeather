//
//  WeatherViewModel.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/24.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherViewModel: ObservableObject {
    
    private let service = WeatherService()
    @Published var currentWeather: Weather?
    
    func getWeatherFromLocation(currentLocation: CLLocation) async -> Weather? {
        
        do {
            let weather = try await service.weather(for: currentLocation)
            
            dump(weather)
            
            DispatchQueue.main.async {
                self.currentWeather = Weather(
                    temperature: weather.currentWeather.temperature.value,
                    condition: weather.currentWeather.condition.rawValue,
                    symbolName: weather.currentWeather.symbolName
                )
                
            }

        } catch {
            assertionFailure(error.localizedDescription)
        }
        
        dump(currentWeather)
        return currentWeather
    }
    
}
