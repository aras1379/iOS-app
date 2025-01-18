//
//  CoffeeCupModelTest.swift
//  iOSGroup11Tests
//
//  Created by Sara Ljung on 2024-03-13.
//

import XCTest
@testable import iOSGroup11
import SwiftData

final class CoffeeCupModelTest: XCTestCase {

    var modelContext: ModelContext!
    var viewModel: StartPageView.ViewModel!
    var mockImageModel: MockImageModel!
    
   @MainActor override func setUpWithError() throws {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContext = try! ModelContainer(for: Category2.self, TodoTask.self, CoffeeCup.self, configurations: configuration).mainContext
        viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: MockImageModel())
        
        let initialCoffeeCup = CoffeeCup(fillLevel: 0)
        modelContext.insert(initialCoffeeCup)
        try modelContext.save()
    }
    override func tearDown() {
        
        modelContext = nil
        super.tearDown()
    }
    
    func testCoffeeCupFillLevelUpdates() throws {
        //FIRST: add todo - mark as done - check cup is full (14)
        var fullCup = 14
        let todo = viewModel.addTodo(title: "Finish report", isPrio: true, isDone: false)
        modelContext.insert(todo)
        
        viewModel.toggleIsDone(todo: todo)
        
        try modelContext.save()
        
        let descriptor = FetchDescriptor<CoffeeCup>(predicate: nil)
        let coffeeCups = try modelContext.fetch(descriptor)
        let coffeeCup = coffeeCups.first!
        
        let expectedFillLevel = fullCup / 1
        XCTAssertEqual(coffeeCup.fillLevel, expectedFillLevel, "FillLevel for 1 todo not correct")
        
        //2ND: add 2nd todo - not marked done - check cup half full (7)
        let todo2 = viewModel.addTodo(title: "Finish report", isPrio: true, isDone: false)
        modelContext.insert(todo)
        try modelContext.save()
        
        viewModel.updateFillLevel()
        
        let expectedFillLevel2 = fullCup / 2
        XCTAssertEqual(coffeeCup.fillLevel, expectedFillLevel2, "Fillevel for 2 todos not correct.")
    }
}
