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
    @State private var exerciseMinutes: Double = 0.0
    @State private var isAuthorized: Bool = true
    @State private var isHealthKitAuthorized: Bool = UserDefaults.standard.bool(forKey: "isHKAuthorized")
    @State private var isFamilyAuthorized: Bool = UserDefaults.standard.bool(forKey: "isFamilyAuthorized")
    @State private var isModePopupVisible = false
    @State private var isGoalSet = false
    @State private var isExercisePopupVisible = false
    
    var body: some View {
        ScrollView {
            VStack {
                // Header Section
                headerSection
                
                if (modes.first(where: {$0.isActive == true }) == nil) {
                    //MARK: Remove isAuthorized for prod
                    if (isHealthKitAuthorized && isFamilyAuthorized) || isAuthorized {
                        modeSelectionButtons
                    }
                }
                if (modes.first(where: {$0.isSelected == true }) != nil) && (goals.first(where: {$0.isSelected == true }) != nil) {
                    TimerSettingView(isPresented: .constant(true), stepsTaken: $stepsTaken, exerciseMinutes: $exerciseMinutes)
                        .environmentObject(model)
                }
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
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Text("SET THE G0ALS")
                .font(.custom("ShareTechMono-Regular", size: 50))
            
            Text("D0 THE W0RK")
                .font(.custom("ShareTechMono-Regular", size: 50))
            
            if isHealthKitAuthorized {
                goalDisplay
            } else {
                authorizationRequest
            }
        }
        .padding()
    }
    
    private var goalDisplay: some View {
        ForEach(goals) { goal in
            if goal.isSelected {
                if goal.exerciseType == .steps {
                    stepsGoalView(goal: goal)
                } else if goal.exerciseType == .minutes {
                    minutesGoalView(goal: goal)
                }
            }
        }
    }
    
    private func stepsGoalView(goal: ExerciseModel) -> some View {
        VStack {
            HStack {
                Spacer()
                ProgressRing(current: stepsTaken, goal: Double(goal.value), type: .steps)
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("You're just \(Int(goal.value) - Int(stepsTaken)) steps away from completing your goal!")
                .font(.custom("ShareTechMono-Regular", size: 17))
        }
    }
    
    private func minutesGoalView(goal: ExerciseModel) -> some View {
        VStack {
            HStack {
                Spacer()
                ProgressRing(current: exerciseMinutes, goal: Double(goal.value), type: .minutes)
                Spacer()
            }
            .padding(.bottom, 10)
            
            Text("You're just \(Int(goal.value) - Int(exerciseMinutes)) minutes away from completing your goal!")
                .font(.custom("ShareTechMono-Regular", size: 17))
        }
    }
    
    private var authorizationRequest: some View {
        VStack {
            Text("We need your permission to access your health and screen time data. Your data will always remain private.")
                .font(.custom("ShareTechMono-Regular", size: 18))
                .padding(.top)
            
            Button(action: authorize) {
                Text("Authorize")
                    .font(.custom("ShareTechMono-Regular", size: 18))
                    .padding(50)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 4)
            }
        }
    }
    
    private var modeSelectionButtons: some View {
        VStack {
            Button(action: {
                isModePopupVisible = true
            }) {
                Text("SELECT MODE")
                    .font(.custom("VT323-Regular", size: 18))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
            .padding(.horizontal)
            
            Button(action: {
                isExercisePopupVisible = true
            }) {
                Text("SET GOALS")
                    .font(.custom("VT323-Regular", size: 18))
//                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
            .padding(.horizontal)
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
            if (modes.first(where: {$0.isLocked == true }) == nil) {
                LockButton {
                    Task {
                        await setLock()
                        BlockTimeTracker.shared.startTracking() // When blocking starts
                    }
                }
            } else {
                UnlockButton {
                    Task {
                        await setUnlock()
                        BlockTimeTracker.shared.stopTracking() // When blocking starts
                    }
                }
                .alert("Goals Not Met", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("You need to complete your fitness goals before unblocking apps.")
                }
            }
        }
    }
    
    func setLock() async {
        model.setShieldRestrictions()
        if let activeMode = modes.first(where: { $0.isSelected }) {
            activeMode.isActive = true
            activeMode.isLocked = true
            print("Lock set")
            try? modelContext.save()
        }
    }
    
    func setUnlock() async {
        if areGoalsMet() {
            model.resetDiscouragedItems()
            if let activeMode = modes.first(where: { $0.isSelected }) {
                activeMode.isActive = false
                activeMode.isLocked = false
                print("Unlock set")
            }
            try? modelContext.save()
        } else {
            showAlert = true
        }
    }
    
    func areGoalsMet() -> Bool {
        //The issue is here
        if let goal = goals.first(where: { $0.isSelected }) {
            switch goal.exerciseType {
            case .steps:
                if stepsTaken < Double(goal.value) {
                    print("GOAL NOT MET STEPS")
                    return false
                }
            case .minutes:
                if exerciseMinutes < Double(goal.value) {
                    print("GOAL NOT MET MINS")
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
