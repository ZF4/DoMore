//
//  Models.swift
//  Limit
//
//  Created by Zachary Farmer on 1/8/25.
//

import SwiftData
import Foundation

@Model
final class BlockModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var isActive: Bool = false
    var isSelected: Bool = false
    var applicationTokens: Data?
    var categoryTokens: Data?

    init(title: String, applicationTokens: Data? = nil, categoryTokens: Data? = nil) {
        self.id = UUID()
        self.title = title
        self.applicationTokens = applicationTokens
        self.categoryTokens = categoryTokens
    }
}
