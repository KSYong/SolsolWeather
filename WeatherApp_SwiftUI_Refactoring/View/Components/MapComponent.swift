//
//  MapComponent.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/11/10.
//

import SwiftUI
import MapKit

struct MapComponent: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        Map(coordinateRegion: $region)
            .padding(EdgeInsets(top: 60, leading: 20, bottom: 40, trailing: 20))
    }
}

struct MapComponent_Previews: PreviewProvider {
    static var previews: some View {
        MapComponent()
    }
}
