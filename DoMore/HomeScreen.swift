//
//  HomeScreen View.swift
//  Limit
//
//  Created by Zachary Farmer on 1/3/25.
//

import SwiftUI
import SwiftData
import FamilyControls

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var blockState: [BlockState]
    // @State private var stepsTaken: Int = 3500
    // @State private var stepsGoal: Int = 5000
    // @State private var exerciseMinutes: Int = 20
    // @State private var exerciseGoal: Int = 30
    // @State private var milesCompleted: Double = 2.5
    // @State private var milesGoal: Double = 3.0
    @State var isDiscouragedPresented = false
    @State var isTimerSettingPresented = false
    @EnvironmentObject var model: MyModel
    
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
                    isDiscouragedPresented = true
                }) {
                    Text("Manage Block List")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
                .onChange(of: model.selectionToDiscourage) { selection, oldSelection in
                    isTimerSettingPresented = true // Open timer setting interface after selecting apps
                }
                // Timer Setting Interface
                if isTimerSettingPresented {
                    TimerSettingView(isPresented: $isTimerSettingPresented, onBlock: {
                        toggleBlockState(active: true)
                    }, onUnblock: {
                        toggleBlockState(active: false)
                    })
                        .environmentObject(model)
                }

                // Display current block state
                if let currentState = blockState.first {
                    Text("Block Status: \(currentState.blockActive ? "Active" : "Inactive")")
                        .foregroundColor(currentState.blockActive ? .red : .green)
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
        }
    }
    private func toggleBlockState(active: Bool) {
        if let existingState = blockState.first {
            existingState.blockActive = active
        } else {
            let newState = BlockState(blockActive: active)
            modelContext.insert(newState)
        }
        try? modelContext.save()
    }
}

// MARK: - Subcomponents

struct TimerSettingView: View {
    @Binding var isPresented: Bool
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    @State private var isTimerRunning = false
    @EnvironmentObject var model: MyModel

    var onBlock: () -> Void
    var onUnblock: () -> Void

    var body: some View {
        VStack {
            // Block Apps Button
            Button(action: {
                 model.setShieldRestrictions()
                 onBlock()
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
                onUnblock()
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
    
    // Function to format remaining time as HH:MM:SS
    private func formattedTime(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
    }
}
