//
//  NetworkError.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case decodingFailed(description: String)
    case invalidResponse
    case invalidURL
    case clientError(code: Int)
    case serverError(code: Int)
    case unknownError(code: Int)
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed(let description):
            String(format: Localized.clientError, description)
        case .invalidResponse:
            Localized.invalidResponse
        case .invalidURL:
            Localized.invalidURL
        case .clientError(let code):
            String(format: Localized.clientError, code)
        case .serverError(let code):
            String(format: Localized.serverError, code)
        case .unknownError(let code):
            String(format: Localized.unknownError, code)
        }
    }
}

extension NetworkError {
    enum Localized {
        static let decodingFailed = String(localized: "NEDecodingFailed")
        static let invalidResponse = String(localized: "NEInvalidResponse")
        static let invalidURL = String(localized: "NEInvalidURL")
        static let clientError = String(localized: "NEClientError")
        static let serverError = String(localized: "NEServerError")
        static let unknownError = String(localized: "NEUnknownError")
    }
}
