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
    @Query private var modes: [BlockModel]
    // @State private var stepsTaken: Int = 3500
    // @State private var stepsGoal: Int = 5000
    // @State private var exerciseMinutes: Int = 20
    // @State private var exerciseGoal: Int = 30
    // @State private var milesCompleted: Double = 2.5
    // @State private var milesGoal: Double = 3.0
    @EnvironmentObject var model: MyModel
    @State private var isPopupVisible = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                //                VStack(alignment: .leading) {
                //                    Text("Daily Progress")
                //                        .font(.title)
                //                        .fontWeight(.bold)
                //                    ProgressCard(title: "Steps", current: Double(stepsTaken), goal: Double(stepsGoal), unit: "steps")
                //                    Text("You're just \(stepsGoal - stepsTaken) steps away from unlocking your favorite apps!")
                //                        .font(.subheadline)
                //                        .foregroundColor(.gray)
                //                }
                //                .padding()
                //
                //                 //Active Blocked Apps Section
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
                    isPopupVisible = true
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
//                .padding(.bottom, 50)
                
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
            .popover(isPresented: $isPopupVisible) {
                ModePopupView()
            }
        }
    }
    
//    private func toggleBlockState(active: Bool) {
//        if let existingState = modes.first {
//            existingState.isActive = active
//        } else {
//            let newState = BlockModel(isActive: active)
//            modelContext.insert(newState)
//        }
//        try? modelContext.save()
//    }
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
    }
}
