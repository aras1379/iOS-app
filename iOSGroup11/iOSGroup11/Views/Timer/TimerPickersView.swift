//
//  TimerPickersView.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-03-14.
//

import SwiftUI

struct TimerPickersView: View {
    
    @Bindable var timerViewModel: TimerViewModel
    
    var body: some View {
        HStack {
          Picker(selection: $timerViewModel.hours, label: Text("Hours")) {
                ForEach(0..<24) { hour in
                    Text(timerViewModel.isTimerStarted ? "0" : "\(hour)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 50)
            Text(":")
           Picker(selection: $timerViewModel.minutes, label: Text("Minutes")) {
                ForEach(0..<60) { minute in
                    Text(timerViewModel.isTimerStarted ? "0" : "\(minute)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 50)
            Text(":")
           Picker(selection: $timerViewModel.seconds, label: Text("Seconds")) {
                ForEach(0..<60) { second in
                    Text(timerViewModel.isTimerStarted ? "0" : "\(second)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 50)
            .disabled(timerViewModel.isTimerStarted)
        }
    }
}
