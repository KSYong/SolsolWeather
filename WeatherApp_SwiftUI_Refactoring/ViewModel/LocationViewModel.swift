//
//  LocationManager.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/18.
//

import Foundation
import CoreLocation
import MapKit

final class LocationViewModel: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    @Published var prevLocation: CLLocation?
    @Published var hasPermission: Bool = false
    @Published var cityName: String = ""
    @Published var stateName: String = ""
    @Published var selectedLocation = CLLocation(latitude: 37.5666791, longitude: 126.9782914)
    @Published var selectedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    @Published var isUsingCurrentLocation = false
    var isFirstTimeLocationUsed = true
        
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   // 위치 정확도 최상
        locationManager.distanceFilter = kCLDistanceFilterNone  // 모든 위치 움직임에 notification 받기
        locationManager.requestAlwaysAuthorization() // 권한 요청하기
        locationManager.startUpdatingLocation() // 위치 정보 받아오기
        locationManager.delegate = self
    }
    
    /// CLLocation을 기반으로 장소 이름을 가져오는 함수
    /// - Parameters:
    ///   - location: place name을 검색할 location
    ///   - completion: 찾은 장소 이름으로 수행할 컴플리션 핸들러
    func setPlaceName(for location: CLLocation) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("[❌] Error in \(#function): \(error!.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("[❌] Error in \(#function): placemark가 nil 입니다.")
                return
            }
                        
            if let cityName = placemark.locality,
               let stateName = placemark.administrativeArea {
                self.cityName = cityName
                self.stateName = stateName
            } else if let cityName = placemark.locality {
                self.cityName = cityName
            } else if let cityName = placemark.name {
                self.cityName = cityName
            } else {
                self.cityName = ""
            }
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewModel: CLLocationManagerDelegate {
    
    // 새로운 위치 데이터가 생기면 수행할 동작 구현
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, currentLocation == nil else {
            return
        }
        
        DispatchQueue.main.async {
            self.currentLocation = location
            
            if self.isFirstTimeLocationUsed == true {
                self.prevLocation = location
                self.setPlaceName(for: location)
                self.isFirstTimeLocationUsed = false
            }
        }
        
        if let prevLocation = self.prevLocation {
            if location.distance(from: prevLocation) >= 1000 {  // 이전에 날씨 api를 사용한 위치로부터 1km 떨어지면 날씨 추적하기
                self.prevLocation = location
                self.setPlaceName(for: location)
            }
        }
    }
    
    // 위치 데이터 받아올 시 에러 처리
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Error : location manager가 위치 값을 받아오는 데 실패하였습니다. :: \(error.localizedDescription)")
    }
    
    // GPS 접근 권한 변경 시 처리
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            hasPermission = false
            print("위치 권한 상태 : \(hasPermission)")
        case .restricted:
            hasPermission = false
            print("위치 권한 상태 : \(hasPermission)")
        case .denied:
            hasPermission = false
            print("위치 권한 상태 : \(hasPermission)")
        case .authorizedAlways:
            hasPermission = true
            print("위치 권한 상태 : \(hasPermission)")
        case .authorizedWhenInUse:
            hasPermission = true
            print("위치 권한 상태 : \(hasPermission)")
        @unknown default:
            print("⁉️ Error : locationMagerDidChangeAuthorization 에서 unknown case가 발생하였습니다")
        }
    }
    
}
