//
//  ContentView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        if locationViewModel.hasPermission {    // 위치 권한 획득했다면 메인 뷰
            WeatherView()
        } else {    // 위치 권한 없으면 도시 검색 뷰
            NavigationStack(){
                SearchView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView()
    }
}
