//
//  MapView.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2023/01/28.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Binding var selectedRegion: MKCoordinateRegion
    @Binding var showUserLocation: Bool
    @Binding var isLocationButtonOn: Bool
    @Binding var isCitySelected: Bool
    
    @State var userDragged = false
    
    let mapView = MKMapView()
    
    typealias UIViewType = MKMapView
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.mapType = .standard
        mapView.animatedZoom(zoomRegion: selectedRegion, duration: 0.1)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = showUserLocation
        if isCitySelected {
            uiView.setRegion(MKCoordinateRegion(center: selectedRegion.center, latitudinalMeters: CLLocationDistance(exactly: 7000)!, longitudinalMeters: CLLocationDistance(exactly: 7000)!), animated: true)
            isCitySelected = false
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        
        var parent: MapView
        var gestureRecognizer = UIPanGestureRecognizer()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.gestureRecognizer.cancelsTouchesInView = false
            self.gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestreHandler))
            self.gestureRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gestureRecognizer)
        }
        
        @objc func panGestreHandler(recognizer:UIPanGestureRecognizer) {
            if recognizer.state == .began {
                self.parent.showUserLocation = false
                self.parent.isLocationButtonOn = false
                self.parent.userDragged = true
            }
            
            if recognizer.state == .ended {
                self.parent.userDragged = false
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.parent.mapView.setRegion(MKCoordinateRegion(center: self.parent.selectedRegion.center, latitudinalMeters: CLLocationDistance(exactly: 7000)!, longitudinalMeters: CLLocationDistance(exactly: 7000)!), animated: true)
        }
        
    }
    
}

extension MKMapView {
    
    func animatedZoom(zoomRegion: MKCoordinateRegion, duration: TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
        }, completion: nil)
    }
    
}
