//
//  ExerciseModel.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/23/25.
//

import SwiftData
import Foundation

@Model
final class ExerciseModel {
    enum ExerciseType: Codable {
        case steps
        case minutes
        
        var rawValue: String {
            switch self {
            case .steps:
                return "Steps"
            case .minutes:
                return "Minutes"
            }
        }
    }
    
    @Attribute(.unique) var id: UUID
    var exerciseType: ExerciseType
    var title: String
    var value: Int
    var isActive: Bool = false
    var isSelected: Bool = false

    init(title: String, exerciseType: ExerciseType = .steps, value: Int) {
        self.id = UUID()
        self.title = title
        self.value = value
        self.exerciseType = exerciseType
    }
}
