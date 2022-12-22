//
//  LocationView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/16.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
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
            
            List(viewModel.completions) { item in
                HStack {
                    Text(item.title)
                    Text(item.subtitle)
                }
            }
            .padding()
            .preferredColorScheme(.dark)
        }
        
        .searchable(text: $viewModel.searchQuery)
        .navigationTitle("도시 탐색")
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
