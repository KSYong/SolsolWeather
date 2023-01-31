//
//  Home.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI
import WeatherKit
import MapKit

struct WeatherView: View {
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @State var pushActive = false
    @State var isUsingCurrentLocation = false
    @State var isLocationButtonOn = true
    @State var selectedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    @State var showUserLocation = true
    @State var isCitySelected = false
    
    var body: some View {
        NavigationStack() {
            GeometryReader { geometry in
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack(spacing: 1) {
                        
                        Spacer()
                        
                        weatherInfo()
                            .onChange(of: locationViewModel.currentLocation, perform: { newValue in
                                if let currentLocation = locationViewModel.currentLocation {
                                    Task {
                                        print(locationViewModel.hasPermission)
                                        do {
                                            try await weatherViewModel.getWeatherFromLocation(currentLocation: currentLocation)
                                        } catch {
                                            print("[ERROR] : 날씨 정보 가져오기 실패 \(error.localizedDescription)")
                                        }
                                    }
                                    locationViewModel.selectedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
                                }
                            })
                       
                        MapView(selectedRegion: $selectedRegion, showUserLocation: $showUserLocation, isLocationButtonOn: $isLocationButtonOn, isUsingCurrentLocation: $isUsingCurrentLocation, isTapped: $isCitySelected)
                            .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
                            .sync($locationViewModel.selectedRegion, with: $selectedRegion)
                            .sync($searchViewModel.isCitySelected, with: $isCitySelected)
                            .onAppear() {
                                selectedRegion = locationViewModel.selectedRegion
                            }
                        
                        Spacer()
                        
                        if locationViewModel.hasPermission {
                            tabBar()
                        }
                    }
                }
                .preferredColorScheme(.dark)
            }
            
            .sheet(isPresented: $pushActive) {
                NavigationView() {
                    SearchView()
                }
            }
        }
    }
    
    @ViewBuilder
    func weatherInfo() -> some View {
        VStack(spacing: 10) {
            
            Text(locationViewModel.cityName)
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical)
            
            Image(systemName: weatherViewModel.weatherImageName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size:75))
            
            Text(weatherViewModel.weatherCondition)
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.white)
            
            tempInfo()
                .offset(x: 18)
            
            HStack {
                Text("최저 : \(weatherViewModel.minTemp)")
                    .font(.system(size:20, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(radius: 1)
                Text("최고 : \(weatherViewModel.maxTemp)")
                    .font(.system(size:20, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(radius: 1)
            }
        }
    }
    
    @ViewBuilder
    func tempInfo() -> some View {
        HStack {
            Text(String(weatherViewModel.currentTemp))
                .font(.system(size:75, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 1)
            Text("°")
                .font(.system(size:75, weight: .medium))
                .foregroundColor(Color("FontColor"))
                .shadow(radius: 1)
        }
    }
    
    @ViewBuilder
    func tabBar() -> some View {
        ZStack {
            HStack {
                Button() {
                    if locationViewModel.hasPermission {
                        pushActive = true
                    }
                } label: {
                    Image(systemName: "map")
                        .font(.system(size:30))
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                                
                Spacer()
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size:30))
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 20))
            }
            
            Button {
                if !isLocationButtonOn {
                    selectedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationViewModel.currentLocation!.coordinate.latitude, longitude: locationViewModel.currentLocation!.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
                    showUserLocation = true
                    isLocationButtonOn = true
                } else {
                    showUserLocation = false
                    isLocationButtonOn = false
                }
            } label: {
                if isLocationButtonOn {
                    Image(systemName: "location.fill")
                        .font(.system(size:30))
                        .fontWeight(.light)
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "location")
                        .font(.system(size:30))
                        .fontWeight(.light)
                        .foregroundColor(.white)
                }
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
        }
        .ignoresSafeArea()
        .frame(maxHeight: 44)
    }
    
}

struct Home_Previews: PreviewProvider {
    
    static var previews: some View {
        WeatherView()
            .environmentObject(dev.locationViewModel)
            .environmentObject(dev.weatherViewModel)
    }
    
}
