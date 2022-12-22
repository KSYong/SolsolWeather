//
//  WeatherViewModel.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/24.
//

import Foundation
import WeatherKit
import CoreLocation

final class WeatherViewModel: ObservableObject {
    
    @Published var currentTemp = ""
    @Published var minTemp = ""
    @Published var maxTemp = ""
    @Published var weatherCondition = ""
    @Published var weatherImageName = ""
    
    private let service = WeatherService.shared
    private let measurementFormatter = MeasurementFormatter()
    
    func getWeatherFromLocation(currentLocation: CLLocation) async {
        
        do {
            let weather = try await service.weather(for: currentLocation)
                                            
            measurementFormatter.locale = Locale(identifier: "ko_KR")
            measurementFormatter.numberFormatter.maximumFractionDigits = 0
            measurementFormatter.numberFormatter.roundingMode = .halfEven
            
            DispatchQueue.main.async {
                self.currentTemp = String(Int(round(weather.currentWeather.temperature.value)))
                self.minTemp = String(self.measurementFormatter.string(from: weather.dailyForecast[0].lowTemperature).dropLast())
                self.maxTemp = String(self.measurementFormatter.string(from: weather.dailyForecast[0].highTemperature).dropLast())
                self.weatherCondition = self.setConditionDescription(for: weather.currentWeather.condition)
                self.weatherImageName = self.setSystemImageName(for: weather.currentWeather.condition)
            }

        } catch {
            print("![ERROR] : 날씨 정보 가져오기 실패")
            assertionFailure(error.localizedDescription)
        }
    }

}

extension WeatherViewModel {
    
    func setConditionDescription(for condition: WeatherCondition) -> String {
        switch condition {
        case .blizzard:
            return "눈보라"
        case .blowingDust:
            return "먼지 날림"
        case .blowingSnow:
            return "날리는 눈"
        case .breezy:
            return "산들바람"
        case .clear:
            return "맑음"
        case .cloudy:
            return "흐림"
        case .drizzle:
            return "이슬비"
        case .flurries:
            return "잠시 눈"
        case .foggy:
            return "안개"
        case .freezingDrizzle:
            return "진눈깨비"
        case .freezingRain:
            return "어는 비"
        case .frigid:
            return "매우 추움"
        case .hail:
            return "우박"
        case .haze:
            return "실안개"
        case .heavyRain:
            return "폭우"
        case .heavySnow:
            return "폭설"
        case .hot:
            return "더움"
        case .hurricane:
            return "허리케인"
        case .isolatedThunderstorms:
            return "국지성 뇌우"
        case .mostlyClear:
            return "대체로 청명"
        case .mostlyCloudy:
            return "대체로 흐림"
        case .partlyCloudy:
            return "조금 흐림"
        case .rain:
            return "비"
        case .scatteredThunderstorms:
            return "산발적 뇌우"
        case .sleet:
            return "진눈깨비"
        case .smoky:
            return "연기"
        case .snow:
            return "눈"
        case .strongStorms:
            return "강한 폭풍"
        case .sunFlurries:
            return "얕은 햇빛"
        case .sunShowers:
            return "강한 햇빛"
        case .thunderstorms:
            return "폭풍우"
        case .tropicalStorm:
            return "열대성 폭풍"
        case .windy:
            return "바람"
        case .wintryMix:
            return "진눈깨비"
        @unknown default:
            print("[DEBUG]: unknown default occured at \(#function)")
            return condition.rawValue
        }
    }
    
    func setSystemImageName(for condition: WeatherCondition) -> String {
        switch condition {
        case .blizzard:
            return "cloud.snow.fill"
        case .blowingDust:
            return "wind"
        case .blowingSnow:
            return "wind.snow"
        case .breezy:
            return "wind"
        case .clear:
            return "sun.max.fill"
        case .cloudy:
            return "cloud.fill"
        case .drizzle:
            return "cloud.drizzle.fill"
        case .flurries:
            return "cloud.sleet.fill"
        case .foggy:
            return "cloud.fog.fill"
        case .freezingDrizzle:
            return "cloud.sleet.fill"
        case .freezingRain:
            return "cloud.sleet.fill"
        case .frigid:
            return "thermometer.snowflake"
        case .hail:
            return "cloud.hail.fill"
        case .haze:
            return "cloud.fog.fill"
        case .heavyRain:
            return "cloud.heavyrain.fill"
        case .heavySnow:
            return "cloud.snow.fill"
        case .hot:
            return "thermometer.sun.fill"
        case .hurricane:
            return "hurricane"
        case .isolatedThunderstorms:
            return "cloud.bolt.fill"
        case .mostlyClear:
            return "sun.max.fill"
        case .mostlyCloudy:
            return "cloud.sun.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .rain:
            return "cloud.rain.fill"
        case .scatteredThunderstorms:
            return "cloud.bolt.fill"
        case .sleet:
            return "cloud.sleet.fill"
        case .smoky:
            return "smoke.fill"
        case .snow:
            return "snowflake"
        case .strongStorms:
            return "cloud.bolt.rain.fill"
        case .sunFlurries:
            return "sun.max.fill"
        case .sunShowers:
            return "sun.max.fill"
        case .thunderstorms:
            return "cloud.bolt.rain.fill"
        case .tropicalStorm:
            return "tropicalstorm"
        case .windy:
            return "wind"
        case .wintryMix:
            return "cloud.sleet.fill"
        @unknown default:
            print("[DEBUG]: unknown default occured at \(#function)")
            return ""
        }
    }
    
}
