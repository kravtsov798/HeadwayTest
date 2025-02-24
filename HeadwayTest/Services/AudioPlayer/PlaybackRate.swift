//
//  PlaybackRate.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import Foundation

enum PlaybackRate: Float, CaseIterable {
    case half = 0.5
    case threeQuarters = 0.75
    case normal = 1
    case oneQuarter = 1.25
    case oneHalf = 1.5
    case oneThreeQuarters = 1.75
    case double = 2
    
    func next() -> Self {
        guard let idx = PlaybackRate.allCases.firstIndex(of: self) else {
            return .normal
        }
        let nextIdx = idx + 1
        return PlaybackRate.allCases.indices.contains(nextIdx) ? PlaybackRate.allCases[nextIdx] : .half
    }
}
