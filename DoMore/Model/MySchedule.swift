//
//  MySchedule.swift
//  Limit
//
//  Created by Zachary Farmer on 1/8/25.
//

import Foundation
import DeviceActivity
import ManagedSettingsUI

// The Device Activity name is how I can reference the activity from within my extension
extension DeviceActivityName {
    // Set the name of the activity to "daily"
    static let daily = Self("daily")
}

// I want to remove the application shield restriction when the child accumulates enough usage for a set of guardian-selected encouraged apps
extension DeviceActivityEvent.Name {
    // Set the name of the event to "encouraged"
    static let discourage = Self("discourage")
}

// The Device Activity schedule represents the time bounds in which my extension will monitor for activity
let schedule = DeviceActivitySchedule(
    // I've set my schedule to start and end at midnight
    intervalStart: DateComponents(hour: 0, minute: 0),
    intervalEnd: DateComponents(hour: 11, minute: 17),
    // I've also set the schedule to repeat
    repeats: true
)

class MySchedule {
    static public func setSchedule() {
        print("Setting schedule...")
        print("Hour is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)

        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .discourage: DeviceActivityEvent(
                applications: MyModel.shared.selectionToDiscourage.applicationTokens,
                threshold: DateComponents(minute: 5)
            )
        ]

        // Create a Device Activity center
        let center = DeviceActivityCenter()
        do {
            print("Try to start monitoring...")
            // Call startMonitoring with the activity name, schedule, and events
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error monitoring schedule: ", error)
        }
    }
  
}
