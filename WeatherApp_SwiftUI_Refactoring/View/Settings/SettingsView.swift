//
//  SettingsView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State var isLocationGranted = false
    @State var sendEmail = false
    
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
                Section(header: Text("기타")) {
                    Button() {
                        sendEmail.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                            Text("문의하기")
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $sendEmail, content: {
            MailView(body: "문의 내용을 작성해 주세요", to: "ericyong95@gmail.com", subject: "")
        })
        
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
