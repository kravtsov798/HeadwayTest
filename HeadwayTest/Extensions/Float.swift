//
//  Float.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 19.02.2025.
//

import Foundation

extension Float {
    /// Returns a formatted string representation of the float number.
    ///
    /// - If the number is a whole number (has no decimal part), it is formatted without decimal places.
    /// - Otherwise, it is converted to a string with its original representation.
    var formattedString: String {
        truncatingRemainder(dividingBy: 1) == 0
        ? String(format: "%.0f", self)
        : String(self)
    }
}
