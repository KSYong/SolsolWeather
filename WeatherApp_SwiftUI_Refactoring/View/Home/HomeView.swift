//
//  Home.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 1) {
                    
                    Spacer()
                    
                    weatherInfo()
                    MapComponent()
                    
                    Spacer()
                    
                    tabBar()
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    @ViewBuilder
    func weatherInfo() -> some View {
        VStack(spacing: 10) {
            
            Text("서울특별시")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom)
            
            Image(systemName: "cloud.bolt.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(size:75))
            
            Text("맑음")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
            
            tempInfo()
                .offset(x: 18)
            
            HStack {
                Text("최저 : 15°")
                    .font(.system(size:20, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(radius: 1)
                Text("최고 : 28°")
                    .font(.system(size:20, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(radius: 1)
            }
        }
    }
    
    @ViewBuilder
    func tempInfo() -> some View {
        HStack {
            Text("26")
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
                NavigationLink(destination: SearchView()) {
                    Image(systemName: "map")
                        .font(.system(size:30))
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0))
                
                Spacer()
            
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .font(.system(size:30))
                        .fontWeight(.thin)
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 20))
            }
            
            Button {
                
            } label: {
                Image(systemName: "location")
                    .font(.system(size:30))
                    .fontWeight(.light)
                    .foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
        }
        .ignoresSafeArea()
        .frame(maxHeight: 44)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
