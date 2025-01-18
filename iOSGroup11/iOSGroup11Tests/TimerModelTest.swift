//
//  TimerViewModelTest.swift
//  iOSGroup11Tests
//
//  Created by Jenny Gran on 2024-03-13.
//

import XCTest
@testable import iOSGroup11

final class TimerViewModelTest: XCTestCase {
    
    //tests if clearTimer() method resets the timer properties correctly
    func testClearTimer() throws {
        let timerViewModel = TimerViewModel()
        
        timerViewModel.hours = 1
        timerViewModel.minutes = 30
        timerViewModel.seconds = 45
        
        timerViewModel.startTimer()
        
        XCTAssertTrue(timerViewModel.isTimerStarted)
        
        timerViewModel.clearTimer()
        
        XCTAssertFalse(timerViewModel.isTimerStarted)
        
        XCTAssertEqual(timerViewModel.hours, 0)
        XCTAssertEqual(timerViewModel.minutes, 0)
        XCTAssertEqual(timerViewModel.seconds, 0)
        XCTAssertEqual(timerViewModel.progress, 1.0)
        XCTAssertEqual(timerViewModel.timerValue, "00:00:00")
        XCTAssertEqual(timerViewModel.remainingTime, 0)
    }
    
    //tests if the timer stops when time is up and if the timer displays "Done" when it reaches 0
    func testTimerCompletion() throws {
        let timerViewModel = TimerViewModel()
        
        timerViewModel.hours = 0
        timerViewModel.minutes = 0
        timerViewModel.seconds = 1
        
        timerViewModel.startTimer()
        
        //https://www.waldo.com/blog/waiting-in-xctest-guide
        //https://developer.apple.com/documentation/xctest/xctestexpectation
        let expectation = XCTestExpectation(description: "Timer completion")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(timerViewModel.isTimerRunning)
            
            XCTAssertEqual(timerViewModel.timerValue, "Done")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    //tests so that the timer updates correctly
    func testTimerUpdate() throws {
        let timerViewModel = TimerViewModel()
        timerViewModel.hours = 0
        timerViewModel.minutes = 0
        timerViewModel.seconds = 10

        timerViewModel.startTimer()

        let expectation = XCTestExpectation(description: "Timer update")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //after one second
            XCTAssert(timerViewModel.timerValue == "00:00:09")
            //progress: remainingTime/staticRemainingTime, meaning 9/10 in this case, meaning 0.9
            XCTAssert(timerViewModel.progress == 0.9)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
}
