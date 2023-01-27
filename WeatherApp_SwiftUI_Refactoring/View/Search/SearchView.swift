//
//  LocationView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/16.
//

import SwiftUI
import CoreLocation
import MapKit

struct SearchView: View {
    
    @EnvironmentObject private var locationViewModel: LocationViewModel
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    @State var isPresented = false
    @State var searchQuery = ""
        
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
                        locationViewModel.selectedLocation = selectedLocation
                        locationViewModel.selectedRegion = MKCoordinateRegion(center: selectedLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
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
            WeatherView()
        })
        .sync($searchViewModel.searchQuery, with: $searchQuery)
        .searchable(text: $searchQuery)
        .navigationTitle("도시 탐색")
        .navigationBarTitleDisplayMode(.large)
        .if(!locationViewModel.hasPermission) { view in // 위치 권한이 없을 때만 설정 버튼 추가하기
            view.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size:20))
                                .fontWeight(.light)
                                .foregroundColor(.white)
                        
                    }
                }
            }
        }
    }
    
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
