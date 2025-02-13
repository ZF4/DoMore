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
    @State private var distanceTraveled: Double = 0.0
    @State private var stepsGoal: Double = 5000
    @State private var exerciseMinutes: Double = 0.0
    @State private var exerciseGoal: Double = 30
    @State private var isAuthorized: Bool = true
    @State private var isHealthKitAuthorized: Bool = UserDefaults.standard.bool(forKey: "isHKAuthorized")
    @State private var isFamilyAuthorized: Bool = UserDefaults.standard.bool(forKey: "isFamilyAuthorized")
    @State private var isModePopupVisible = false
    @State private var isGoalSet = false
    @State private var isExercisePopupVisible = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                VStack(alignment: .leading) {
                    
                    Text("SET THE GOALS")
                        .font(.system(size: 50, weight: .heavy, design: .monospaced))

                    Text("DO THE WORK")
                        .font(.system(size: 50, weight: .heavy, design: .monospaced))

                    //MARK: Remove isGoalSet for prod
                    if isHealthKitAuthorized {
                        ForEach(goals) { goal in
                            if goal.isSelected {
                                if goal.exerciseType == .steps {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            ProgressRing(current: stepsTaken, goal: Double(goal.value), type: .steps)
                                            Spacer()
                                            
                                        }
                                        .padding(.bottom, 10)
                                        
                                        Text("You're just \(Int(goal.value) - Int(stepsTaken)) steps away from completing your goal!")
                                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                            .foregroundColor(.gray)
                                    }
                                } else if goal.exerciseType == .minutes {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            ProgressRing(current: exerciseMinutes, goal: Double(goal.value), type: .minutes)
                                            Spacer()
                                            
                                        }
                                        .padding(.bottom, 10)
                                        
                                        Text("You're just \(Int(goal.value) - Int(exerciseMinutes)) minutes away from completing your goal!")
                                            .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                        }
                        
                    } else {
                        Text("We need your permission to access your health and screen time data. Your data will always remain private.")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .padding(.top)
                        
                        Button(action: authorize) {
                            Text("Authorize")
                                .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                .padding(50)
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(radius: 4)
                        }
                    }
                }
                .padding()
                
                if (modes.first(where: {$0.isActive == true }) == nil) {
                    //MARK: Remove isAuthorized for prod
                    if (isHealthKitAuthorized && isFamilyAuthorized) || isAuthorized {
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
                }
                    TimerSettingView(isPresented: .constant(true), stepsTaken: $stepsTaken, exerciseMinutes: $exerciseMinutes)
                        .environmentObject(model)
                
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
                } distanceHandler: { distance in
                    DispatchQueue.main.async {
                        self.distanceTraveled = distance
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
    private func authorize() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                isHealthKitAuthorized = true
                UserDefaults.standard.set(true, forKey: "isHKAuthorized")
                print("Authorization successful")
                // Fetch initial data if needed
                fetchHealthData()
            } else {
                isHealthKitAuthorized = false
                print("Authorization failed: \(String(describing: error))")
            }
        }
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                isFamilyAuthorized = true
                UserDefaults.standard.set(true, forKey: "isFamilyAuthorized")
                print("Authorization successful")
                // Handle successful authorization (e.g., update UI or fetch data)
            } catch {
                isFamilyAuthorized = false
                print("Authorization failed: \(error)")
            }
        }
    }
    
    private func fetchHealthData() {
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

#Preview {
    let preview = Preview()
    preview.addBlockExamples(BlockModel.sampleItems)
    preview.addExerciseExamples(ExerciseModel.sampleItems)
    return ContentView()
        .environmentObject(MyModel())
        .modelContainer(preview.modelContainer)
}
