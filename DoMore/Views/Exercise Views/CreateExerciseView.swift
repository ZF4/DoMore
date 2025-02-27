//
//  AddExerciseView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/23/25.
//

import SwiftUI
import SwiftData

struct CreateExerciseView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss // To dismiss the view
    @State private var selectedActivity: ExerciseModel.ExerciseType = .steps // Track selected activity
    @State private var inputValue: String = "" // User input
    @State private var errorMessage: String? = nil // Error message for validation
    @State private var exerciseModel: ExerciseModel?
    @State var showDelete: Bool = false
    @State private var goalID: UUID?
    @Binding var currentGoal: ExerciseModel?

    
    //MARK: Create ExerciseModel, save and maybe make different modes? Idk
    var body: some View {
        NavigationStack {
            mainContent
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 20) {
            // Activity Type Selection
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    //MARK: Add photos for different activity types
                    Text("ACTIVITY TYPE  -")
                        .font(.system(size: 15, weight: .semibold))
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding(.leading)
                    
                    Text(selectedActivity.rawValue.uppercased())
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.gray)
                }

                
                if selectedActivity == .steps {
                    Text("Your Screen Time will not be restored until you have met the step goal.")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                        .padding(.horizontal)
                    
                } else if selectedActivity == .minutes {
                    Text("Your Screen Time will not be restored until you have met the number of minutes exercised goal.")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                        .padding(.horizontal)
                    
                }
            }
            
            // Input Section
            VStack(alignment: .leading, spacing: 10) {
                Text("ENTER \(selectedActivity.rawValue.uppercased())")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                TextField("e.g. 5000", text: $inputValue)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundStyle(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            // Save Button
            Button(action: saveActivity) {
                Text("SAVE")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Cancel Button
            Button(action: { dismiss() }) {
                Text("CANCEL")
                    .font(.headline)
                    .foregroundColor(.red)
            }
        }
        .toolbar {
//            if showDelete {
//                ToolbarItem(placement: .topBarTrailing) {
//                    deleteButton
//                }
//            }
            
            ToolbarItem(placement: .topBarLeading) {
                dismissButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("SET GOAL")
        .onAppear {
            if let currentGoal {
                goalID = currentGoal.id
                inputValue = String(currentGoal.value)
                selectedActivity = currentGoal.exerciseType
                showDelete = true
            }
        }
    }
    
//    private var deleteButton: some View {
//        Button {
//            deleteGoal(goalID!)
//        } label: {
//            Image(systemName: "trash")
//                .bold()
//        }
//        .tint(.gray)
//    }
    
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .bold()
        }
        .tint(.gray)
    }
    
//    private func deleteGoal(_ goalToDelete: UUID) {
//        // Find and delete the mode with matching name
//        if let modeToRemove = try? modelContext.fetch(FetchDescriptor<ExerciseModel>())
//            .first(where: { $0.id == goalToDelete }) {
//            modelContext.delete(modeToRemove)
//        }
//    }
    
//    private func setActivity() {
//        if selectedActivity == .steps {
//            exerciseModel = ExerciseModel(title: "Steps", exerciseType: .steps, value: Int(inputValue) ?? 0)
//        } else if selectedActivity == .minutes {
//            exerciseModel = ExerciseModel(title: "Minutes", exerciseType: .minutes, value: Int(inputValue) ?? 0)
//        }
//    }
    
    private func saveActivity() {
        guard let value = Int(inputValue), value > 0 else {
            errorMessage = "Please enter a valid number for \($selectedActivity)."
            return
        }
        
        errorMessage = nil // Clear previous errors
//        setActivity() // Set the exercise model before saving
        if let currentGoal {
            currentGoal.value = Int(inputValue) ?? 0
            dismiss() // Dismiss after saving
        }
    }
}

struct ActivityTypeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.black.opacity(0.2) : Color.white)
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(10)
                .shadow(radius: 1)
        }
    }
}

#Preview {
    CreateExerciseView(currentGoal: .constant(ExerciseModel(title: "test", exerciseType: .steps, value: 50)))
}
