//
//  Models.swift
//  Limit
//
//  Created by Zachary Farmer on 1/8/25.
//

import SwiftData
import Foundation

@Model
final class BlockState {
    @Attribute(.unique) var id: UUID
    var blockActive: Bool

    init(blockActive: Bool = false) {
        self.id = UUID()
        self.blockActive = blockActive
    }
}

@Model
final class ModeModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var applicationTokens: Data?
    var categoryTokens: Data?

    init(title: String, applicationTokens: Data? = nil, categoryTokens: Data? = nil) {
        self.id = UUID()
        self.title = title
        self.applicationTokens = applicationTokens
        self.categoryTokens = categoryTokens
    }
}
