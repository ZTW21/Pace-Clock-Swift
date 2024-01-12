//
//  ContentView.swift
//  Pace Clock Watch App
//
//  Created by Zack Wilson on 1/12/24.
//

import SwiftUI
import Combine
import UIKit

struct ContentView: View {
    @State var startTime = Date()
    @State var elapsedTime: TimeInterval = 0
    @State private var timerRunning = false
    let clock = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var cancellable: Cancellable?
    
    var body: some View {
        VStack {
            if minutesElapsed > 0 {
                HStack {
                    Text("\(minutesElapsed)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            HStack(spacing: 0) {
                ForEach(clockDisplay.map { String($0) }, id: \.self) { digit in
                    Text(digit)
                        .font(.custom("Digital-7", size: 80))
                        .frame(width: 35, alignment: .center) // Fixed width for each character
                }
            }
            .padding()
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
                
                if !timerRunning {
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .padding()
                }
            }
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
}

#Preview {
    ContentView()
}
