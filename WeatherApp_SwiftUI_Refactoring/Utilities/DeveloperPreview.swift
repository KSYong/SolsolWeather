//
//  PreviewProvider.swift
//  WeatherApp_SwiftUI_Refactoring
//
//  Created by 권승용 on 2023/01/04.
//

import Foundation
import SwiftUI

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {}
    
    let locationViewModel = LocationViewModel()
    let weatherViewModel = WeatherViewModel()
    let searchViewModel = SearchViewModel()
    
}

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}
