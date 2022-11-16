//
//  LocationView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/16.
//

import SwiftUI

struct LocationView: View {
    @State var serachText: String = ""
    
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
                Section {
                    Text("도시 이름")
                }
            }
            .preferredColorScheme(.dark)
            
        }
        
        .searchable(text: $serachText)
        .navigationTitle("도시 탐색")
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
