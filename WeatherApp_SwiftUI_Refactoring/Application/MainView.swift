//
//  ContentView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
