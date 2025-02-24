//
//  AudioPlayerError.swift
//  HeadwayTest
//
//  Created by Andrii Kravtsov on 24.02.2025.
//

import Foundation

enum AudioPlayerError: LocalizedError {
    case invalidURL
    case playerInitFailed(desciption: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            Localized.invalidURL
        case .playerInitFailed(let desciption):
            String(format: Localized.playerInitFailed, desciption)
        }
    }
}

extension AudioPlayerError {
    enum Localized {
        static let invalidURL = String(localized: "APEInvalidURL")
        static let playerInitFailed = String(localized: "APEPlayerInitFailed")
    }
}
