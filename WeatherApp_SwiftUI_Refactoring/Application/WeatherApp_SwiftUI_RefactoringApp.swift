//
//  WeatherApp_SwiftUI_RefactoringApp.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI

@main
struct WeatherApp_SwiftUI_RefactoringApp: App {
    private var locationManager = LocationManager()
    private var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.colorScheme, .dark)
                .environmentObject(locationManager)
                .environmentObject(weatherViewModel)
        }
    }
}

