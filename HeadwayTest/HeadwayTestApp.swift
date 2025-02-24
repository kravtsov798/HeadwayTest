//
//  HeadwayTestApp.swift
//  HeadwayTest
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import ComposableArchitecture
import SwiftUI

@main
struct HeadwayTestTaskApp: App {
    static let store = Store(initialState: SummaryFeature.State()) {
        SummaryFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            SummaryView(store: HeadwayTestTaskApp.store)
        }
    }
}
