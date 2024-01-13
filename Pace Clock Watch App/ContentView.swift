//
//  ContentView.swift
//  Pace Clock Watch App
//
//  Created by Zack Wilson on 1/12/24.
//

import SwiftUI
import Combine
import UIKit
import HealthKit

struct ContentView: View {
    @State var startTime = Date()
    @State var elapsedTime: TimeInterval = 0
    @State private var timerRunning = false
    let clock = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var cancellable: Cancellable?
    
    let workoutManager = WorkoutManager()
    @State private var workoutActive = false
    
    var body: some View {
        VStack {
            Spacer()
            if minutesElapsed > 0 {
                HStack {
                    Text("\(minutesElapsed)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding([.leading, .top])
            }
            HStack(spacing: 0) {
                ForEach(Array(clockDisplay.enumerated()), id: \.offset) { index, digit in
                    Text(String(digit))
                        .font(.custom("Digital-7", size: 80))
                        .frame(width: 35, alignment: .center) // Fixed width for each character
                }
            }
            .padding([.leading, .bottom, .trailing])
            
            HStack {
                if !timerRunning {
                    Button(action: startTimer){
                        Image(systemName: "play.fill")
                    }
                    .padding()
                }
                
                if timerRunning {
                    Button(action: pauseTimer){
                        Image(systemName: "pause.fill")
                    }
                    .padding()
                }
                
                if !timerRunning && elapsedTime != 0    {
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .padding()
                }
            }
            if workoutActive {
                Button(action: stopButton) {
                    Text("Stop Workout")
                }
                .background(Color.red)
            }
            Spacer()
        }
    }
    
    private var minutesElapsed: Int {
        Int(elapsedTime / 60)
    }
    
    private var clockDisplay: String {
        let totalMilliseconds = Int(elapsedTime * 100)
        let seconds = totalMilliseconds / 100 % 60
        let milliseconds = totalMilliseconds % 100
        
        return String(format: "%02d:%02d", seconds, milliseconds)
    }
    
    private func startTimer() {
        if !timerRunning {
            startTime = Date() - elapsedTime
            cancellable = clock.sink { _ in
                elapsedTime = Date().timeIntervalSince(startTime)
            }
            workoutManager.startWorkout()
            workoutActive = true
            timerRunning = true
        }
    }
    
    private func pauseTimer() {
        cancellable?.cancel()
        timerRunning = false
    }
    
    private func resetTimer() {
        pauseTimer()
        elapsedTime = 0
    }
    
    private func stopButton() {
        pauseTimer()
        resetTimer()
        workoutManager.stopWorkout()
        workoutActive = false
    }
}

#Preview {
    ContentView()
}
