//
//  StatsViewModel.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/19/25.
//

import Foundation
import Combine

class StatsViewModel: ObservableObject {
    @Published var daysBlocked: Int = 0
    @Published var hoursBlocked: Int = 0
    @Published var minutesBlocked: Int = 0
    @Published var todaysSteps: Double = 0.0
    @Published var todaysMins: Double = 0.0
    @Published var lastSevenDaysSteps: Int = 0
    @Published var lastSevenDaysMins: Int = 0
    @Published var allTimeSteps: Int = 0
    @Published var allTimeMins: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Start a timer to update the blocked time every second
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateBlockedTime()
            }
            .store(in: &cancellables)
        
        // Fetch initial health data
        fetchHealthDataHistory()
    }
    
    private func updateBlockedTime() {
        daysBlocked = BlockTimeTracker.shared.totalBlockedDays
        hoursBlocked = BlockTimeTracker.shared.totalBlockedHours
        minutesBlocked = BlockTimeTracker.shared.totalBlockedMinutes
    }
    
    func fetchHealthDataToday() {
        HealthKitManager.shared.fetchStepCount { steps in
            DispatchQueue.main.async {
                self.todaysSteps = steps
            }
        }
        
        HealthKitManager.shared.fetchExerciseMinutes { mins in
            DispatchQueue.main.async {
                self.todaysMins = mins
            }
        }
    }
    
    func fetchHealthDataHistory() {
        HealthKitManager.shared.fetchLast7DaysData { lastSevenDaysSteps, lastSevenDaysMins in
            DispatchQueue.main.async {
                self.lastSevenDaysSteps = lastSevenDaysSteps
                self.lastSevenDaysMins = lastSevenDaysMins
            }
        }
        
        HealthKitManager.shared.fetchTotalStepsAndExerciseMinutes { allTimeSteps, allTimeMins in
            DispatchQueue.main.async {
                self.allTimeSteps = allTimeSteps
                self.allTimeMins = allTimeMins
            }
        }
    }
}
