//
//  Preview.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/1/25.
//

import Foundation
import SwiftData

struct Preview {
    
    let modelContainer: ModelContainer
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: ExerciseModel.self, BlockModel.self, configurations: config)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    func addExerciseExamples(_ examples: [ExerciseModel]) {
        Task { @MainActor in
            examples.forEach { example in
                modelContainer.mainContext.insert(example)
            }
        }
    }
    
    func addBlockExamples(_ examples: [BlockModel]) {
        Task { @MainActor in
            examples.forEach { example in
                modelContainer.mainContext.insert(example)
            }
        }
    }

}
