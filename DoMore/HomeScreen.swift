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
                                if goal.exerciseType == .steps {
                                    ProgressCard(title: goal.title, current: stepsTaken, goal: Double(goal.value), unit: goal.title.lowercased())
                                } else if goal.exerciseType == .minutes {
                                    ProgressCard(title: goal.title, current: exerciseMinutes, goal: Double(goal.value), unit: goal.title.lowercased())
                                }
                                
                                Text("You're just \(Int(stepsGoal) - Int(stepsTaken)) steps away from unlocking your favorite apps!")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Text("Set your exercise goal to begin your blocking session!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text("Please authorize HealthKit access to view progress.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
                .padding()
                //Active Blocked Apps Section
                //                VStack(alignment: .leading) {
                //                    Text("Blocked Apps")
                //                        .font(.title2)
                //                        .fontWeight(.bold)
                //                    ScrollView(.horizontal, showsIndicators: false) {
                //                        HStack(spacing: 15) {
                //                            ForEach(1..<5) { index in
                //                                BlockedAppCard(appName: "App \(index)", progress: 0.75)
                //                            }
                //                        }
                //                    }
                //                }
                //                .padding(.horizontal)
                
                Button(action: {
                    isModePopupVisible = true
                }) {
                    Text("SELECT MODE")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
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
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.horizontal, 30)
                
                TimerSettingView(isPresented: .constant(true))
                    .environmentObject(model)
                
                // Display current block state
                if let currentState = modes.first(where: { $0.isActive }) {
                    Text("Block Status: \(currentState.isActive ? "Active" : "Inactive")")
                        .foregroundColor(currentState.isActive ? .red : .green)
                }
                
                // Fitness Challenges Section
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
            .onAppear(perform: fetchHealthData)
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
    
    //    var onBlock: () -> Void
    //    var onUnblock: () -> Void
    
    var body: some View {
        VStack {
            // Block Apps Button
            Button(action: {
                model.setShieldRestrictions()
                // Set active block to true
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
                model.resetDiscouragedItems()
                // Set all blocks to inactive
                for mode in modes {
                    mode.isActive = false
                }
                try? modelContext.save()
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
        }
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

struct BlockedAppCard: View {
    var appName: String
    var progress: Double
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .overlay(Text("A").font(.title).foregroundColor(.white))
            Text(appName)
                .font(.subheadline)
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(width: 100)
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

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(MyModel())
            .modelContainer(for: BlockModel.self, inMemory: true)
            .modelContainer(for: ExerciseModel.self, inMemory: true)
    }
}
