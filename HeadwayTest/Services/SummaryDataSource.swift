//
//  SummaryDataSource.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 18.02.2025.
//

import Foundation
import Dependencies

enum SummaryDataSourceDependencyKey: DependencyKey {
    static let liveValue: DataSource = SummaryDataSource()
}

extension DependencyValues {
    var summaryDataSource: DataSource {
        get { self[SummaryDataSourceDependencyKey.self] }
        set { self[SummaryDataSourceDependencyKey.self] = newValue }
    }
}

protocol DataSource {
    var currentKeyPoint: SummaryKeyPoint? { get }
    
    var currentKeyPointNumber: Int? { get }
    var keyPointsCount: Int { get }
    
    var isFirstKeyPoint: Bool { get }
    var isLastKeyPoint: Bool { get }
    
    var summaryCover: String? { get }
    
    func update(summary: Summary)
    func moveToNext()
    func moveToPrev()
}

class SummaryDataSource: DataSource {
    var currentKeyPoint: SummaryKeyPoint? {
        guard isValidCurrentPointIdx else { return nil }
        return keyPoints[currentKeyPointIdx]
    }
    
    var keyPointsCount: Int { keyPoints.count }
    
    var isFirstKeyPoint: Bool {
        guard isValidCurrentPointIdx else { return false }
        return currentKeyPointIdx == 0
    }
    
    var isLastKeyPoint: Bool {
        guard isValidCurrentPointIdx else { return false }
        return currentKeyPointIdx == keyPointsCount - 1
    }
    
    var currentKeyPointNumber: Int? {
        guard isValidCurrentPointIdx else { return nil }
        return currentKeyPointIdx + 1
    }
    
    var summaryCover: String? { summary?.imagePath }
    
    private var isValidCurrentPointIdx: Bool {
        keyPoints.indices.contains(currentKeyPointIdx)
    }
    
    private var currentKeyPointIdx = -1
    private var summary: Summary?
    private var keyPoints: [SummaryKeyPoint] { summary?.keyPoints ?? [] }
    
    func update(summary: Summary) {
        self.summary = summary
        currentKeyPointIdx = 0
    }
    
    func moveToNext() {
        guard !isLastKeyPoint else { return }
        
        let newIdx = currentKeyPointIdx + 1
        updateCurrentKeyPointIdxIfPossible(with: newIdx)
    }
    
    func moveToPrev() {
        guard !isFirstKeyPoint else { return }
        
        let newIdx = currentKeyPointIdx - 1
        updateCurrentKeyPointIdxIfPossible(with: newIdx)
    }
    
    private func updateCurrentKeyPointIdxIfPossible(with newIdx: Int) {
        if keyPoints.indices.contains(newIdx) {
            currentKeyPointIdx = newIdx
        }
    }
}
