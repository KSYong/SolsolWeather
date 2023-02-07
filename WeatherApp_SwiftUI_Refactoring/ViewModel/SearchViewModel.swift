//
//  SearchViewModel.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2022/12/15.
//

import Foundation
import MapKit
import Combine

final class SearchViewModel: NSObject, ObservableObject {
    
    @Published var searchQuery = ""
    @Published var completions: [MKLocalSearchCompletion] = []
    @Published var searchResults = [[String]]()
    
    @Published var selectedLatitude: Double?
    @Published var selectedLongitude: Double?
    @Published var isCitySelected = false
    
    var completer: MKLocalSearchCompleter
    var cancellable: AnyCancellable?
    
    override init() {
        completer = MKLocalSearchCompleter()
        completer.region = MKCoordinateRegion(.world)
        completer.resultTypes = .address
        super.init()
        cancellable = $searchQuery.assign(to: \.queryFragment, on: self.completer)
        completer.delegate = self
    }
    
    func getCoordinates(by completion: MKLocalSearchCompletion) async throws {
        let request = MKLocalSearch.Request(completion: completion)
                
        do {
            let response = try await MKLocalSearch(request: request).start()
            await MainActor.run {
                selectedLatitude = response.mapItems[0].placemark.coordinate.latitude
                selectedLongitude = response.mapItems[0].placemark.coordinate.longitude
            }
        } catch {
            print("[ERROR] : MKLocalSearch request failed with error \(error.localizedDescription)")
            throw error
        }
    }
}

extension SearchViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.completions = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("[ERROR] : MKLocalSearchCompleter 에러 :: \(error.localizedDescription)")
    }
}

extension MKLocalSearchCompletion: Identifiable {}
