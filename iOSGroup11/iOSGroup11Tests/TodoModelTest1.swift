//
//  TodoModelTest.swift
//  iOSGroup11Tests
//
//  Created by Sara Ljung on 2024-03-14.
//

import XCTest
@testable import iOSGroup11
import SwiftData

final class TodoModelTest: XCTestCase {
    
    var modelContext: ModelContext!
    
    var mockImageModel: MockImageModel!
    
    @MainActor override func setUp() {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContext = try! ModelContainer(for: Category2.self, TodoTask.self, CoffeeCup.self, configurations: configuration).mainContext
        mockImageModel = MockImageModel()
    }
    override func tearDown() {
        modelContext = nil
        super.tearDown()
    }
    
    func testDeleteAllDoneTodos(){
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: mockImageModel)
        
        let category1 = Category2(title: "Category1")
        let category2 = Category2(title: "Category2")
        
        let todo1 = viewModel.addTodo(title: "Todo11", isPrio: true, isDone: true)
        viewModel.addTodoToCategory(todo: todo1, category: category1)
        let todo2 = viewModel.addTodo(title: "Todo2", isPrio: true, isDone: false)
        viewModel.addTodoToCategory(todo: todo2, category: category1)
        let todo3 = viewModel.addTodo(title: "Todo3", isPrio: true, isDone: false)
        viewModel.addTodoToCategory(todo: todo3, category: category1)
        let todo4 = viewModel.addTodo(title: "Todo4", isPrio: true, isDone: true)
        viewModel.addTodoToCategory(todo: todo4, category: category2)
        
        viewModel.deleteAllDoneTodos()
        
        XCTAssertEqual(viewModel.todos.count, 2, "should be 2 todo remaining")
        let todo5 = viewModel.addTodo(title: "Todo5", isPrio: true, isDone: true)
        viewModel.addTodoToCategory(todo: todo5, category: category2)
        
        viewModel.deleteAllDoneTodos(in: category1)
        
        XCTAssertEqual(viewModel.todos.filter { $0.category == category1 }.count, 2, "should be 2 todo left in category1")
        XCTAssertEqual(viewModel.todos.filter { $0.category == category2 }.count, 1, "should be 1 todo left in category2")
    }
    
    func testAddTodo(){
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: mockImageModel)
        
        let todosCount = viewModel.todos.count
        let todoTitle = "Test Todo"
        let isPrio = true
        let isDone = false
        let date = Date()
        
        let newTodo = viewModel.addTodo(title: todoTitle, isPrio: isPrio, isDone: isDone, date: date)
        
        XCTAssertEqual(viewModel.todos.count, todosCount + 1, "Todos should increase by 1")
        XCTAssertTrue(viewModel.todos.contains(where: { $0.id == newTodo.id && $0.title == todoTitle && $0.isPrio == isPrio && $0.isDone == isDone }), "todo should have correct properties")
    }
    
    //Test by jenny
    func testOnlyPriosDisplayed() throws {
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: mockImageModel)
        
        let category = Category2(title: "Category 1", imageId: "imageId1")
        let category2 = Category2(title: "Category 2", imageId: "imageId2")
        
        let prioTodo = TodoTask(title: "Prio", isDone: false, isPrio: true, date: nil, category: category)
        let nonPrioTodo = TodoTask(title: "Non Prio", isDone: false, isPrio: false, date: nil, category: category2)
        
        viewModel.todos = [prioTodo, nonPrioTodo]
        
        XCTAssertTrue(viewModel.prioTodos.contains {$0.title == "Prio"})
        XCTAssertFalse(viewModel.prioTodos.contains{$0.title == "Non Prio"})
    }
    //Test by jenny
       //tests that todos are sorted correctly when marked as done
    func testSortedTodos() throws {
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: mockImageModel)
        
        let category = Category2(title: "Category 1", imageId: "imageId1")
        let category2 = Category2(title: "Category 2", imageId: "imageId2")
        let category3 = Category2(title: "Category 3", imageId: "imageId3")
        
        let todo1 = TodoTask(title: "Todo 1", isDone: true, isPrio: false, date: nil, category: category)
        let todo2 = TodoTask(title: "Todo 2", isDone: false, isPrio: false, date: nil, category: category2)
        let todo3 = TodoTask(title: "Todo 3", isDone: false, isPrio: false, date: nil, category: category3)
        
        viewModel.todos = [todo1, todo2, todo3]
        
        viewModel.sortTodos()
        
        let sortedTodos = viewModel.todos
        
        XCTAssertEqual(sortedTodos, [todo2, todo3, todo1])
    }
    //Test by jenny 
       //tests so that todos are edited correctly
    func testEditingTodo() throws {
        let viewModel = StartPageView.ViewModel(modelContext: modelContext, imageHandler: mockImageModel)
        
        let category1 = Category2(title: "Category 1", imageId: "imageId1")
        let category2 = Category2(title: "Category 2", imageId: "imageId2")
        
        let todo1 = TodoTask(title: "Todo 1", isDone: false, isPrio: false, date: nil, category: category1)
        let todo2 = TodoTask(title: "Todo 2", isDone: false, isPrio: false, date: nil, category: category2)
        viewModel.todos = [todo1, todo2]
        
        let todoToEdit = viewModel.todos[0]
        
        //try to update title, date and prio
        let newTitle = "Edited todo"
        let newPrio = true
        let newDate = Date()
        
        todoToEdit.title = newTitle
        todoToEdit.isPrio = newPrio
        todoToEdit.date = newDate
        
        XCTAssertEqual(viewModel.todos.count, 2) //make sure another todo didn't get added
        XCTAssertEqual(viewModel.todos[0].title, newTitle)
        XCTAssertEqual(viewModel.todos[0].isPrio, newPrio)
        XCTAssertEqual(viewModel.todos[0].date, newDate)
    }
}
