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
    
    @Published var currentWeather: Weather = Weather(temperature: 0, condition: "", symbolName: "", minTemperature: "", maxTemperature: "")
    
    private let service = WeatherService()
    private let measurementFormatter = MeasurementFormatter()
    
    func getWeatherFromLocation(currentLocation: CLLocation) async {
        
        do {
            let weather = try await service.weather(for: currentLocation)
                                
            measurementFormatter.locale = Locale(identifier: "ko_KR")
            
            DispatchQueue.main.async {
                self.currentWeather = Weather(
                    temperature: weather.currentWeather.temperature.value,
                    condition: weather.currentWeather.condition.rawValue,
                    symbolName: weather.currentWeather.symbolName,
                    minTemperature: self.measurementFormatter.string(from: weather.dailyForecast[0].lowTemperature),
                    maxTemperature: self.measurementFormatter.string(from: weather.dailyForecast[0].highTemperature)
                )
            }

        } catch {
            print("[❌] Error : 날씨 정보 가져오기 실패")
            assertionFailure(error.localizedDescription)
        }
    }
    
}
