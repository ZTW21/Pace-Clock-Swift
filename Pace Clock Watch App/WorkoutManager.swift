//
//  WorkoutManager.swift
//  Pace Clock Watch App
//
//  Created by Zack Wilson on 1/13/24.
//

import HealthKit

class WorkoutManager {
    let healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKWorkoutBuilder?
    var workoutStartDate: Date?
    
    init() {
        requestHealthKitAuthorization()
    }
    
    private func requestHealthKitAuthorization() {
        // Define the data types your app will be using
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available")
            return
        }
        
        let typesToShare: Set = [
            HKObjectType.workoutType()
            // Include other data types your app will write
        ]
        
        let typesToRead: Set = [
            HKObjectType.workoutType()
            // Include other data types your app will read
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error = error {
                print("Error requesting HealthKit authorization: \(error)")
            }
        }
    }
    
    func startWorkout() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .swimming
        workoutConfiguration.swimmingLocationType = .pool
        workoutConfiguration.lapLength = HKQuantity(unit: .yard(), doubleValue: 25.0)
        
        do {
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            self.workoutSession = session
            self.workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: nil)
            
            session.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date()) { success, error in
                if let error = error {
                    print("Error starting workout builder: \(error)")
                }
            }
        } catch {
            // Handle errors here
            print("Error starting workout session: \(error)")
        }
    }
    
    func stopWorkout() {
        let endDate = Date()
        
        workoutSession?.stopActivity(with: endDate)
        workoutSession?.end()
        
        workoutBuilder?.endCollection(withEnd: endDate) { success, error in
            guard success else {
                print("Error ending workout builder collection: \(error?.localizedDescription ?? "")")
                return
            }
            self.workoutBuilder?.finishWorkout { (workout, error) in
                if let error = error {
                    print("Error saving workout: \(error)")
                } else if let workout = workout {
                    print("Workout saved successfully: \(workout)")
                }
            }
        }
        
        workoutSession = nil
        workoutStartDate = nil
    }
}
