//
//  TimerViewModel.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-20.
//

import Foundation
import SwiftUI

//Kopied jennys file into here 
@Observable
class TimerViewModel {
    var progress: CGFloat = 1
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var remainingTime: Int = 0
    var staticRemainingTime: Int = 0
    var storedRemainingTime: Int = 0
    var isTimerStarted: Bool = false
    var timerValue: String = "00:00:00"
    private var timer: Timer?
    
    
    //https://www.youtube.com/watch?v=Pd90OTQiOaA
    //https://developer.apple.com/documentation/foundation/timer/2091889-scheduledtimer
    func startTimer() {
        timerValue = "\(hours >= 10 ? "\(hours)" : "0\(hours):")\(minutes >= 10 ? "\(minutes)": "0\(minutes):")\(seconds >= 10 ? "\(seconds)": "0\(seconds)")"
        
        remainingTime = (hours * 3600) + (minutes * 60) + seconds
        staticRemainingTime = remainingTime
        
        withAnimation(.easeInOut(duration: 1.0)) {
            isTimerStarted = true
            progress = CGFloat(remainingTime) / CGFloat(staticRemainingTime)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.remainingTime > 0 {
                DispatchQueue.main.async {
                    self.remainingTime -= 1
                    self.updateTimer()
                }
            } else {
                self.stopTimer()
            }
        }
    }
    
    var isTimerRunning: Bool {
        return timer != nil
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerStarted = false
    }
    
    func updateTimer() {
        progress = (CGFloat(remainingTime) / CGFloat(staticRemainingTime))
        progress = (progress < 0 ? 0 : progress)
        
        hours = remainingTime / 3600
        minutes = (remainingTime % 3600) / 60
        seconds = remainingTime % 60
        
        timerValue = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        if (remainingTime == 0) {
            stopTimer()
            timerValue = "Done"
        }
    }
    
    func clearTimer() {
        timerValue = "00:00:00"
        remainingTime = 0
        progress = 1.0
        stopTimer()
        hours = 0
        minutes = 0
        seconds = 0
    }
}
