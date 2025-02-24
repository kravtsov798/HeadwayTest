//
//  TimeInterval.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import Foundation

extension TimeInterval {
    /// Returns a formatted string representation in "MM:SS" format.
    var string: String {
        let minute = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}
