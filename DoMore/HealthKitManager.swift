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
//            if let quantity = statistics?.sumQuantity() {
//                totalDistance = quantity.doubleValue(for: HKUnit.mile()) // Get distance in miles
//            }
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
}

