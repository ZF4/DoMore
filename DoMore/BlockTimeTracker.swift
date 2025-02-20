//
//  BlockTimeTracker.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/19/25.
//

import Foundation

class BlockTimeTracker {
    static let shared = BlockTimeTracker()
    
    private let totalBlockedTimeKey = "totalBlockedTime"
    private let startTimeKey = "startTime" // Key for storing start time
    
    private var totalBlockedTime: TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: totalBlockedTimeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: totalBlockedTimeKey)
        }
    }
    
    private var startTime: Date? {
        get {
            // Retrieve the stored start time from UserDefaults
            if let timeInterval = UserDefaults.standard.object(forKey: startTimeKey) as? TimeInterval {
                return Date(timeIntervalSince1970: timeInterval)
            }
            return nil
        }
        set {
            // Store the start time in UserDefaults
            if let newValue = newValue {
                UserDefaults.standard.set(newValue.timeIntervalSince1970, forKey: startTimeKey)
            } else {
                UserDefaults.standard.removeObject(forKey: startTimeKey)
            }
        }
    }
    
    private var endTime: Date?

    // Method to start tracking blocked time
    func startTracking() {
        print("Block timer started.")
        startTime = Date() // Set the current date as start time
    }
    
    // Method to stop tracking blocked time
    func stopTracking() {
        print("Block timer stopped.")
        endTime = Date()
        
        guard let start = startTime else { return }
        let blockedDuration = endTime?.timeIntervalSince(start) ?? 0
        totalBlockedTime += blockedDuration
        print("Blocked Duration: \(blockedDuration) seconds") // Log the duration
        
        // Reset the start and end times
        startTime = nil
        endTime = nil
    }
    
    // Method to get total blocked time in seconds
    func getTotalBlockedTime() -> TimeInterval {
        return totalBlockedTime
    }
    
    // Method to reset total blocked time
    func resetBlockedTime() {
        totalBlockedTime = 0
    }
    
    // Computed property to get total blocked time as Days
    var totalBlockedDays: Int {
        return Int(totalBlockedTime) / (24 * 3600)
    }
    
    // Computed property to get total blocked time as Hours
    var totalBlockedHours: Int {
        let remainingSeconds = Int(totalBlockedTime) % (24 * 3600)
        return remainingSeconds / 3600
    }
    
    // Computed property to get total blocked time as Minutes
    var totalBlockedMinutes: Int {
        let remainingSeconds = Int(totalBlockedTime) % (24 * 3600)
        let remainingHours = remainingSeconds % 3600
        return remainingHours / 60
    }
}
