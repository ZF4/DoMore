//
//  ExerciseModeView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings

struct ExerciseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var goals: [ExerciseModel]
    @State private var selectedModeId: UUID?
    
    private func setSelectMode(_ selectedGoal: ExerciseModel) {
        // Deactivate all other modes
        for goal in goals {
            goal.isSelected = goal.id == selectedGoal.id
            print("Active: \(goal.isActive)")
            print("Selected: \(goal.isSelected)") 
        }
        
        // Activate the selected mode's restrictions
        if let goal = goals.first(where: { $0.isSelected }) {
            selectGoal(goal: goal)
        }
    }
    
    private func selectGoal(goal: ExerciseModel) {
        print("Selected Goal: \(goal)")
    }
    
    var body: some View {
        VStack {
            ForEach(goals) { goal in
                ExerciseCellView(
                    goal: goal,
                    isSelected: goal.isSelected,
                    onSelect: {
                        setSelectMode(goal)
                    }
                )
            }
        }
        .padding(.top)
    }
}

struct ExerciseCellView: View {
    @State private var showEditGoal: Bool = false
    @State var selectedGoal: ExerciseModel?
    var goal: ExerciseModel
    var isSelected: Bool
    var onSelect: () -> Void
    
    var body: some View {
        ZStack {
            // Centered text
            Text(goal.title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(25)
                .foregroundStyle(.gray)
            
            // Right-aligned button
            HStack {
                Spacer()
                Button(action: {
                    selectedGoal = goal
                    showEditGoal = true
                    selectGoal(goal: goal)
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: goal.isSelected ? 6 : 1)
        .padding(.horizontal, 30)
        .padding(.bottom)
        .popover(isPresented: $showEditGoal) {
            CreateExerciseView(currentGoal: $selectedGoal)
        }
        .onTapGesture {
            selectedGoal = goal
            onSelect()
        }
    }
    // Activate a mode by applying its restrictions
    private func selectGoal(goal: ExerciseModel) {
        
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ExerciseModel.self, configurations: config)

    for i in 1..<3 {
        let user = ExerciseModel(title: "test", value: 10)
        container.mainContext.insert(user)
    }

    return ExerciseListView()
        .modelContainer(container)
}
