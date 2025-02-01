//
//  Samples.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/1/25.
//

import Foundation

extension ExerciseModel {
    static var sampleItems: [ExerciseModel] {
        [
            ExerciseModel(title: "Steps", exerciseType: .steps, value: 3500),
            ExerciseModel(title: "Minutes", exerciseType: .minutes, value: 60)
        ]
    }
}

extension BlockModel {
    static var sampleItems: [BlockModel] {
        [
            BlockModel(title: "Social"),
            BlockModel(title: "Games")
        ]
    }
}
