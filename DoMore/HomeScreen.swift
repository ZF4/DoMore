//
//  HomeScreen View.swift
//  Limit
//
//  Created by Zachary Farmer on 1/3/25.
//

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var model: MyModel
    @Query private var modes: [BlockModel]
    @Query private var goals: [ExerciseModel]
    @State private var stepsTaken: Double = 0.0
    @State private var stepsGoal: Double = 5000
    @State private var exerciseMinutes: Double = 0.0
    @State private var exerciseGoal: Double = 30
    @State private var isAuthorized = false
    @State private var isModePopupVisible = false
    @State private var isGoalSet = false
    @State private var isExercisePopupVisible = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                VStack(alignment: .leading) {
                    Text("Daily Progress")
                        .font(.title)
                        .fontWeight(.bold)
                    if isAuthorized {
                        if !modes.isEmpty {
                            ForEach(goals) { goal in
                                if goal.isSelected {
                                    if goal.exerciseType == .steps {
                                        ProgressCard(title: goal.title, current: stepsTaken, goal: Double(goal.value), unit: goal.title.lowercased())
                                    } else if goal.exerciseType == .minutes {
                                        ProgressCard(title: goal.title, current: exerciseMinutes, goal: Double(goal.value), unit: goal.title.lowercased())
                                    }
                                    
                                    Text("You're just \(Int(stepsGoal) - Int(stepsTaken)) steps away from unlocking your favorite apps!")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                            }
                        } else {
                            Text("Select a mode and set a goal to start tracking your progress!")
                        }
                    } else {
                        Text("Please authorize HealthKit access to view progress.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .padding()
                if (modes.first(where: {$0.isActive == true }) == nil) {
                    Button(action: {
                        isModePopupVisible = true
                    }) {
                        Text("SELECT MODE")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        isExercisePopupVisible = true
                    }) {
                        Text("SET GOALS")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal, 30)
                }
                
                TimerSettingView(isPresented: .constant(true), stepsTaken: $stepsTaken, exerciseMinutes: $exerciseMinutes)
                    .environmentObject(model)
                
                // Display current block state
                if let currentState = modes.first(where: { $0.isActive }) {
                    Text("Block Status: \(currentState.isActive ? "Active" : "Inactive")")
                        .foregroundColor(currentState.isActive ? .red : .green)
                }
                
                //                 Fitness Challenges Section
                //                VStack(alignment: .leading) {
                //                    Text("Fitness Challenges")
                //                        .font(.title2)
                //                        .fontWeight(.bold)
                //                    VStack(spacing: 10) {
                //                        ChallengeCard(title: "Morning Run", details: "3 miles left")
                //                        ChallengeCard(title: "Unlock Instagram", details: "15 minutes of exercise")
                //                    }
                //                }
                //                .padding()
                //
                //                 //Time Reclaimed Section
                //                VStack(alignment: .leading) {
                //                    Text("Time Reclaimed")
                //                        .font(.title2)
                //                        .fontWeight(.bold)
                //                    Text("Total Time Saved: 1h")
                //                        .font(.headline)
                //                    Text("5 miles walked this week")
                //                        .font(.subheadline)
                //                        .foregroundColor(.gray)
                //                }
                //                .padding(.horizontal)
            }
            .onAppear {
                fetchHealthData()
                HealthKitManager.shared.startObservingHealthData { steps in
                    DispatchQueue.main.async {
                        self.stepsTaken = steps
                    }
                } exerciseHandler: { minutes in
                    DispatchQueue.main.async {
                        self.exerciseMinutes = minutes
                    }
                }
            }
            .popover(isPresented: $isModePopupVisible) {
                ModePopupView()
            }
            .popover(isPresented: $isExercisePopupVisible) {
                ExercisePopupView()
            }
        }
    }
    private func fetchHealthData() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                isAuthorized = true
                HealthKitManager.shared.fetchStepCount { steps in
                    DispatchQueue.main.async {
                        stepsTaken = steps
                    }
                }
                HealthKitManager.shared.fetchExerciseMinutes { minutes in
                    DispatchQueue.main.async {
                        exerciseMinutes = minutes
                    }
                }
            } else {
                isAuthorized = false
                print("Authorization failed: \(String(describing: error))")
            }
        }
    }
}

// MARK: - Subcomponents

struct TimerSettingView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var model: MyModel
    @Environment(\.modelContext) private var modelContext
    @Query private var modes: [BlockModel]
    @Query private var goals: [ExerciseModel]
    @State private var showAlert = false
    @Binding var stepsTaken: Double
    @Binding var exerciseMinutes: Double
    
    var body: some View {
        VStack {
            // Block Apps Button
            Button(action: {
                model.setShieldRestrictions()
                if let activeMode = modes.first(where: { $0.isSelected }) {
                    activeMode.isActive = true
                    try? modelContext.save()
                }
            }) {
                Text("Block Apps")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.red)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            
            // Unblock Apps Button
            Button(action: {
                if areGoalsMet() {
                    model.resetDiscouragedItems()
                    for mode in modes {
                        mode.isActive = false
                    }
                    try? modelContext.save()
                } else {
                    showAlert = true
                }
            }) {
                Text("Unblock Apps")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.green)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            .alert("Goals Not Met", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("You need to complete your fitness goals before unblocking apps.")
            }
        }
    }
    func areGoalsMet() -> Bool {
        for goal in goals {
            switch goal.exerciseType {
            case .steps:
                if stepsTaken < Double(goal.value) {
                    return false
                }
            case .minutes:
                if exerciseMinutes < Double(goal.value) {
                    return false
                }
            }
        }
        return true
    }
}

struct ProgressCard: View {
    var title: String
    var current: Double
    var goal: Double
    var unit: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(Int(current))/\(Int(goal)) \(unit)")
                    .font(.subheadline)
            }
            ProgressView(value: current, total: goal)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ChallengeCard: View {
    var title: String
    var details: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(details)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct QuickActionButton: View {
    var title: String
    var icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
        }
    }
}

#Preview {
    let preview = Preview()
    preview.addBlockExamples(BlockModel.sampleItems)
    preview.addExerciseExamples(ExerciseModel.sampleItems)
    return ContentView()
        .environmentObject(MyModel())
        .modelContainer(preview.modelContainer)
}
