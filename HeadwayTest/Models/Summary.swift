//
//  BookSummary.swift
//  HeadwayTestTask
//
//  Created by Andrii Kravtsov on 17.02.2025.
//

import Foundation

struct Summary: Codable, Equatable {
    var author: Author
    var title: String
    var imagePath: String
    var keyPoints: [SummaryKeyPoint]
}
