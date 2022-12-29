//
//  SettingsView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI

struct SettingsView: View {
    
    @State var isLocationGranted = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            List {
                Section(header: Text("위치 정보")) {
                    Toggle(isOn: $isLocationGranted) {
                        Text("위치 정보 사용")
                    }
                }
                Section(header: Text("기타")) {
                    Text("문의하기")
                    Text("개인정보 처리 방침")
                    Text("개발자 정보")
                }
            }
            .preferredColorScheme(.dark)
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
