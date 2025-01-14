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
