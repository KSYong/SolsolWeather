//
//  LocationView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/16.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    
    @EnvironmentObject private var locationViewModel: LocationViewModel
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    @State var isPresented = false
    
    @Environment(\.dismiss) var dismiss
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        List(searchViewModel.completions) { item in
            HStack {
                Text(item.title)
                Text(item.subtitle)
            }
            .onTapGesture {
                Task {
                    do {
                        try await searchViewModel.getCoordinates(by: item)
                        let selectedLocation = CLLocation(latitude: searchViewModel.selectedLatitude!, longitude: searchViewModel.selectedLongitude!)
                        try await weatherViewModel.getWeatherFromLocation(currentLocation: selectedLocation)
                        locationViewModel.setPlaceName(for: selectedLocation)
                    } catch {
                        print("[ERROR]: 날씨 정보 가져오는 중 에러 \(error.localizedDescription)")
                    }
                    
                }
                if locationViewModel.hasPermission {
                    dismiss()
                } else {
                    isPresented = true
                }
                
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        
        .sheet(isPresented: $isPresented, content: {
            HomeView()
        })
        
        .searchable(text: $searchViewModel.searchQuery)
        .navigationTitle("도시 탐색")
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
