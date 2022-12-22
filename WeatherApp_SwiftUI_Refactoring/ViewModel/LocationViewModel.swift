//
//  LocationManager.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/18.
//

import Foundation
import CoreLocation

final class LocationViewModel: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    @Published var hasPermission: Bool = false
    
    @Published var cityName: String = ""
    @Published var stateName: String = ""
        
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
            self.setPlaceName(for: location)
            
        }
    }
    
    // 위치 데이터 받아올 시 에러 처리
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Error : location manager가 위치 값을 받아오는 데 실패하였습니다. :: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            hasPermission = false
        case .restricted:
            hasPermission = false
        case .denied:
            hasPermission = false
        case .authorizedAlways:
            hasPermission = true
        case .authorizedWhenInUse:
            hasPermission = true
        @unknown default:
            print("⁉️ Error : locationMagerDidChangeAuthorization 에서 unknown case가 발생하였습니다")
        }
    }
    
}
