//
//  HealthKitManager.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/23/25.
//

import Foundation
import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    private let launchDateKey = "launchDate" // Key for storing launch date
    
    init() {
        // Check if launch date is already stored
        if UserDefaults.standard.object(forKey: launchDateKey) == nil {
            // If not, set the current date as the launch date
            UserDefaults.standard.set(Date(), forKey: launchDateKey)
        }
    }
    
    // Check if HealthKit is available
    func isHealthDataAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Request Authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard isHealthDataAvailable() else {
            completion(false, nil)
            return
        }
        
        let readTypes: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes, completion: completion)
    }
    // Fetch Distance Traveled For Today
    func fetchDistanceTraveled(completion: @escaping (Double) -> Void) {
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(0.0)
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity()?.doubleValue(for: HKUnit.mile()) else {
                completion(0.0)
                return
            }
            
            completion(sum)
        }
        healthStore.execute(query)
    }
    
    // Fetch Step Count for Today
    func fetchStepCount(completion: @escaping (Double) -> Void) {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion(0.0)
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)
    }
    
    // Fetch Exercise Minutes for Today
    func fetchExerciseMinutes(completion: @escaping (Double) -> Void) {
        guard let exerciseType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(0.0)
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.minute()))
        }
        
        healthStore.execute(query)
    }
    
    func startObservingHealthData(stepsHandler: @escaping (Double) -> Void, exerciseHandler: @escaping (Double) -> Void, distanceHandler: @escaping (Double) -> Void) {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let exerciseType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else {
            return
        }
        
        let distanceQuery = HKObserverQuery(sampleType: distanceType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchDistanceTraveled(completion: distanceHandler)
            }
        }
        
        let stepQuery = HKObserverQuery(sampleType: stepType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchStepCount(completion: stepsHandler)
            }
        }
        
        let exerciseQuery = HKObserverQuery(sampleType: exerciseType, predicate: nil) { _, _, error in
            if error == nil {
                self.fetchExerciseMinutes(completion: exerciseHandler)
            }
        }
        
        healthStore.execute(distanceQuery)
        healthStore.execute(stepQuery)
        healthStore.execute(exerciseQuery)
    }
    
    // Fetch Last 7 Days of Step Count and Exercise Minutes
    func fetchLast7DaysData(completion: @escaping (Int, Int) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        let now = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -6, to: now)! // 7-day range
        let anchorDate = calendar.startOfDay(for: now)
        let interval = DateComponents(day: 1)
        
        let querySteps = HKStatisticsCollectionQuery(quantityType: stepType,
                                                     quantitySamplePredicate: nil,
                                                     options: .cumulativeSum,
                                                     anchorDate: anchorDate,
                                                     intervalComponents: interval)
        
        let queryExercise = HKStatisticsCollectionQuery(quantityType: exerciseType,
                                                        quantitySamplePredicate: nil,
                                                        options: .cumulativeSum,
                                                        anchorDate: anchorDate,
                                                        intervalComponents: interval)
        
        var totalSteps = 0
        var totalMinutes = 0
        
        querySteps.initialResultsHandler = { _, result, _ in
            result?.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                let steps = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                totalSteps += Int(steps)
            }
            self.healthStore.execute(queryExercise)
        }
        
        queryExercise.initialResultsHandler = { _, result, _ in
            result?.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                let minutes = statistics.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0
                totalMinutes += Int(minutes)
            }
            completion(totalSteps, totalMinutes)
        }
        
        healthStore.execute(querySteps)
    }
    
    // Fetch total steps and exercise minutes since app launch
    func fetchTotalStepsAndExerciseMinutes(completion: @escaping (Int, Int) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        
        let now = Date()
        let launchDate = UserDefaults.standard.object(forKey: launchDateKey) as! Date
        
        let predicate = HKQuery.predicateForSamples(withStart: launchDate, end: now, options: .strictStartDate)
        
        let querySteps = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let totalSteps = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            
            // Fetch exercise minutes
            let queryExercise = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                let totalMinutes = result?.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0
                completion(Int(totalSteps), Int(totalMinutes))
            }
            
            self.healthStore.execute(queryExercise)
        }
        
        healthStore.execute(querySteps)
    }
}

