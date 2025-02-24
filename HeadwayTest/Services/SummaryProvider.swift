//
//  BookSummaryProvider.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import Dependencies
import Foundation

enum SummaryProvidingDependencyKey: DependencyKey {
    static let liveValue: SummaryProviding = SummaryProvider()
}

extension DependencyValues {
    var summaryProvider: SummaryProviding {
        get { self[SummaryProvidingDependencyKey.self] }
        set { self[SummaryProvidingDependencyKey.self] = newValue }
    }
}

protocol SummaryProviding {
    func getSummary() async throws -> Summary
}

final class SummaryProvider: SummaryProviding {
    @Dependency(\.networkService)
    private var networkService
    
    private let jsonPath = "https://gist.githubusercontent.com/kravtsov798/a3e11ce9528c1966131de0dd0d9f6188/raw/79f7750a6115167f1485f0bc1dcfc86727484f0e/summary.txt"
    
    func getSummary() async throws -> Summary {
        let url = URL(string: jsonPath)
        return try await networkService.request(url: url)
    }
}
