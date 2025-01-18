//
//  CategoriesModelTest.swift
//  iOSGroup11Tests
//
//  Created by Sara Ljung on 2024-03-11.
//

import XCTest
@testable import iOSGroup11
import SwiftData

//@MainActor
final class CategoriesModelTest: XCTestCase {
    var modelContext: ModelContext!
    var mockImageModel: MockImageModel!
    
    @MainActor override func setUp() {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContext = try! ModelContainer(for: Category2.self, TodoTask.self, configurations: configuration).mainContext
        mockImageModel = MockImageModel()
    }
    override func tearDown() {
        modelContext = nil
        super.tearDown()
    }

       
    func testAddingTodoToCategory() throws {
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: mockImageModel)
  
        let category1 = Category2(title: "Work")
        let category2 = Category2(title: "Personal")
        
        let todo = viewModel.addTodo(title: "Finish report", isPrio: true, isDone: false)
        
        modelContext.insert(category1)
        modelContext.insert(category2)

    
        viewModel.addTodoToCategory(todo: todo, category: category1)
        XCTAssertTrue(category1.todos.contains(where: { $0.id == todo.id }), "todo should be in first category")
        XCTAssertEqual(todo.category, category1, "todo category should be moved to first category")

        viewModel.addTodoToCategory(todo: todo, category: category2)
        XCTAssertFalse(category1.todos.contains(where: { $0.id == todo.id }), "todo should be removed from first category")
        XCTAssertTrue(category2.todos.contains(where: { $0.id == todo.id }), "todo should be in second category")
        XCTAssertEqual(todo.category, category2, "todos category should be moved second category")
    }


   @MainActor func testUpdateCategoryImage() async throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContext = try ModelContainer(for: Category2.self, TodoTask.self, CoffeeCup.self, configurations: configuration).mainContext
        mockImageModel = MockImageModel()
        
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: mockImageModel)
        
        let category = Category2(title: "Test Category", imageId: "oldImage.jpg")
        let newImageURL = "http://example.com/newImage.jpg"
        try await viewModel.updateCategoryImage2(category: category, newImageURL: newImageURL)
        
        XCTAssertEqual(category.imageId, "path/to/mockImage.jpg", "The category's imageId should be updated to the path returned by the mock image downloader.")
    }
    
     
   @MainActor func testCategoryTitleValidation() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContext = try ModelContainer(for: Category2.self, TodoTask.self, CoffeeCup.self, configurations: configuration).mainContext
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: MockImageModel())
        
        XCTAssertThrowsError(try viewModel.validateCategory(title: "")) { error in
            XCTAssertTrue(error is CategoryError, "should be CategoryError, got \(type(of: error))")
            if case CategoryError.missingTitle = error {
                
            } else {
                XCTFail("should be missingTitle error for empty title")
            }
        }
        
        let longTitle = String(repeating: "a", count: 36)
        XCTAssertThrowsError(try viewModel.validateCategory(title: longTitle)) { error in
            XCTAssertTrue(error is CategoryError, "should be CategoryError, got \(type(of: error))")
            if case CategoryError.titleTooLong = error {
            } else {
                XCTFail("should be missingTitle error for empty title")
            }
        }
        
        XCTAssertNoThrow(try viewModel.validateCategory(title: "Title"), "should be no error for valid title")
    }

}
