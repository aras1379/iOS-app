//
//  TimerButtonsView.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-03-14.
//

import SwiftUI

struct TimerButtonsView: View {
    
    @Bindable var timerViewModel: TimerViewModel
    
    var body: some View {
        HStack(spacing: 35) {
            SmallerButton(title: timerViewModel.isTimerStarted ? "Stop" : "Start", action: { if timerViewModel.isTimerStarted { timerViewModel.stopTimer() } else {
                timerViewModel.startTimer()
            }
            })
            SmallerButton(title: "Clear", action: { timerViewModel.clearTimer()
            })
        }
    }
}
