//
//  TimerScreen.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-20.
//

import SwiftUI

//copied jennys code into here 
struct TimerView: View {
    @State private var timerViewModel = TimerViewModel()
    
    var body: some View {
        VStack {
            Text("Timer")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding(3.0)
            NavigationStack {
                VStack(spacing: 40) {
                    ZStack {
                        Circle()
                            .frame(width: 500, height: 250)
                            .foregroundColor(.white)
                        //https://chat.openai.com/share/de112f08-04f6-4ac2-997b-2f58f76fda1d
                        Circle()
                            .trim(from: 0.0, to: CGFloat(timerViewModel.progress))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 250, height: 250)
                            .animation(.easeInOut, value: timerViewModel.progress)
                        Text("\(timerViewModel.timerValue)")
                            .font(.title)
                    }
                    .padding()
                    
                    TimerPickersView(timerViewModel: timerViewModel)
                    
                    TimerButtonsView(timerViewModel: timerViewModel)
                }
                .padding(.bottom, 250)
            }
        }
    }
}

#Preview {
    TimerView()
}
