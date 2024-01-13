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

    func startWorkout() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .swimming
        workoutConfiguration.locationType = .indoor

        do {
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            self.workoutSession = session
            session.startActivity(with: Date())
        } catch {
            // Handle errors here
        }
    }

    func stopWorkout() {
        workoutSession?.stopActivity(with: Date())
        workoutSession?.end()
        workoutSession = nil
    }
}
