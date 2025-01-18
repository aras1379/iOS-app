//
//  CoreVM.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-13.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit

extension StartPageView{
    @Observable
    final class ViewModel{
        private let modelContext: ModelContext
        var imageHandler: ImageHandling
        
        var categories = [Category2]()
        var todos = [TodoTask]()
        var imageModel = ImageModel()
        var images: [ImageData.ApiImage] = []
        
        var errorMessage: String?
        
        var fillLevel = 0
        let totalHeights = 14
        
        init(modelContext: ModelContext, imageHandler: ImageHandling) {
           // modelContext.insert(Category2.defaultCategory)
            self.modelContext = modelContext
            self.imageHandler = imageHandler
            fetchData()
        }
/*
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }*/
 
        func fetchData() {
            do {
                let descriptor = FetchDescriptor<TodoTask>(sortBy: [SortDescriptor(\.title)])
                todos = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
            do {
                let descriptor2 = FetchDescriptor<Category2>(sortBy: [SortDescriptor(\.title)])
                categories = try modelContext.fetch(descriptor2)
            }catch{
                print("Fetch for categories fail")
            }
            
        }
        
/*************
 * CATEGORIES
 *******************/
        func saveCategory(title: String, imageURL: String?) async {
            do{
                try validateCategory(title: title)
                guard let imageURL = imageURL, !imageURL.isEmpty else {
                    return
                }
                let newCategory = Category2(title: title, imageId: nil)
                
                try await updateCategoryImage(category: newCategory, newImageURL: imageURL)
                
                let backgroundImage = try await downloadImageGetFilepath(imageURL: imageURL)
                
                modelContext.insert(newCategory)
                fetchData()
            }catch{
                
            }
        }
        
        // THIS IS ONLY FOR TESTING BC OF AVOID NETWORK CONNECTION IN IMAGEMODEL!!!
        func updateCategoryImage2(category: Category2, newImageURL: String) async throws {
            
            let newImageFileName = URL(string: newImageURL)?.lastPathComponent ?? "default.jpg"
            let newImageFilePath = try await imageHandler.downloadImage(imageURL: newImageURL)
            
            if let currentImageId = category.imageId, !currentImageId.isEmpty {
            }
            category.imageId = newImageFilePath
        }
 
        
        func updateCategory(category: Category2, newImageURL: String, currentImageURL: String?) async throws {
            try await updateCategoryImage(category: category, newImageURL: newImageURL)
               fetchData()
        }
        //https://www.mozzlog.com/blog/how-to-delete-file-swift-using-foundation
        func updateCategoryImage(category: Category2, newImageURL: String) async throws{
            if let currentImageURL = category.imageId, !currentImageURL.isEmpty {
                let currentImagePath = getDocumentsDirectory().appendingPathComponent(currentImageURL).path
                try? FileManager.default.removeItem(atPath: currentImagePath)
            }
            let newImageFilePath = try await downloadImageGetFilepath(imageURL: newImageURL)
            category.imageId = newImageFilePath
            
            fetchData()
        }
        

        func validateCategory(title: String) throws {
            guard !title.isEmpty else {
                throw CategoryError.missingTitle
            }
            guard title.count <= 35 else {
                throw CategoryError.titleTooLong
            }
        }
     
        func deleteCategory(at offsets: IndexSet) {
            offsets.forEach { index in
                let categoryToDelete = categories[index]
                modelContext.delete(categoryToDelete)
            }
            fetchData()
        }
        
     
/*************
 * IMAGES
*******************/
        func downloadImageGetFilepath(imageURL: String) async throws -> String{
            do{
                let filePath = try await imageModel.downloadImage(imageURL: imageURL)
                return filePath
            }catch{
                throw error
            }
        }
        func loadImageFromPath(_ path: String) -> UIImage? {
            let fileURL = getDocumentsDirectory().appendingPathComponent(path)
            return UIImage(contentsOfFile: fileURL.path)
        }
        
        func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        func loadImage(fromImageId imageId: String) -> UIImage? {
            let fileURL = getDocumentsDirectory().appendingPathComponent(imageId)
            return UIImage(contentsOfFile: fileURL.path)
        }
   
 /*************
 * TODOS
 *******************/
        
        //FROM JENNYS COMMIT
        func sortTodos() {
            todos.sort { !$0.isDone && $1.isDone }
        }
        //FROM JENNYS COMMIT
        func filteredTodos(for timeFrame: TimeFrame) -> [TodoTask] {
            todos.filter{$0.timeFrame == timeFrame}
        }
        //FROM JENNYS COMMIT
        static func sortUpcomingTodos(_ todos: [TodoTask]) -> [TodoTask] {
            var upcomingTodos = todos.filter { $0.timeFrame == .Upcoming }
            
            upcomingTodos.sort { (firstTodo, secondTodo) -> Bool in
                if let firstDate = firstTodo.date, let secondDate = secondTodo.date {
                    return firstDate < secondDate
                }
                return false
            }
            upcomingTodos.sort{ !$0.isDone && $1.isDone }
            
            return upcomingTodos
        }
        
        func fetchTodos(forCategoryId categoryId: String) -> [TodoTask] {
            return todos.filter { $0.category?.id == categoryId }
        }
        
        var prioTodos: [TodoTask] {
            todos.filter { $0.isPrio }
        }
        
        func addTodo(title: String, isPrio: Bool, isDone: Bool, date: Date? = nil) -> TodoTask {
            let todo = TodoTask(title: title, isDone: isDone, isPrio: isPrio, date: date, category: nil)
            modelContext.insert(todo)
            fetchData()
            return todo
        }

        func addTodoToCategory(todo: TodoTask, category: Category2) {
            if let oldCategory = todo.category, oldCategory !== category {
                oldCategory.todos.removeAll { $0.id == todo.id }
                
                modelContext.insert(oldCategory)
                fetchData()
            }
            if todo.category !== category {
                category.todos.append(todo)
                todo.category = category
                modelContext.insert(category)
                fetchData()
            }
        }
        
        func toggleIsDone(todoID: String) {
            if let index = todos.firstIndex(where: { $0.id == todoID }) {
                todos[index].isDone.toggle()
                fetchData()
                updateFillLevel()
            }
        }
        
        func deleteTodo(_ todoToDelete: TodoTask) {
            modelContext.delete(todoToDelete)
            do {
                try modelContext.save()
                
                fetchData()
                updateFillLevel()
            } catch {
                print("Error deleting todo and updating fill level: \(error)")
            }
        }
  
        func deleteAllDoneTodos(in category: Category2? = nil){
            var todosToDelete: [TodoTask]
            
            if let category = category {
                todosToDelete = todos.filter { $0.isDone && $0.category == category }
            } else {
                todosToDelete = todos.filter { $0.isDone }
            }
            
            for todo in todosToDelete {
                modelContext.delete(todo)
            }
            
            do {
                try modelContext.save()
                fetchData()
                updateFillLevel()
            } catch {
                print("Error delete todos \(error)")
            }
        }
        
        func todosFiltered(forCategory category: Category2) -> [TodoTask] {
            todos.filter { $0.category?.id == category.id }
        }
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }()
        
/*************
 * COFFECUP
 *******************/
        
        func coffeeImageName(for fillLevel: Int) -> String {
            "cup\(fillLevel)"
        }
        func fetchCurrentFillLevel() {
            let descriptor = FetchDescriptor<CoffeeCup>(predicate: nil)
            do {
                let coffeeCups = try modelContext.fetch(descriptor)
                if let coffeeCup = coffeeCups.first {
                    DispatchQueue.main.async {
                        self.fillLevel = coffeeCup.fillLevel
                    }
                }
            } catch {
                print("Error fetching current fill level: \(error)")
            }
        }
        func toggleIsDone(todo: TodoTask) {
            todo.isDone.toggle()
            do {
                try modelContext.save()
                updateFillLevel()
            } catch {
                print("Error toggling todo completion and updating fill level: \(error)")
            }
        }
        //Help from chat gpt :) 
        func updateFillLevel() {
            let descriptor = FetchDescriptor<CoffeeCup>(predicate: nil)
            do {
                let coffeeCups = try modelContext.fetch(descriptor)
                if let coffeeCup = coffeeCups.first {
                    let completedTodos = todos.filter { $0.isPrio && $0.isDone }.count
                    let totalTodos = todos.filter{$0.isPrio}.count
                    coffeeCup.fillLevel = totalTodos > 0 ? (completedTodos * totalHeights) / totalTodos : 0
                    
                    try modelContext.save()
                    DispatchQueue.main.async {
                        self.fillLevel = coffeeCup.fillLevel
                    }
                }
            } catch {
                print("Error updating fill level: \(error)")
            }
        }
    }
}

enum CategoryError: Error {
    case missingTitle
    case titleTooLong
    var errorMessage: String {
            switch self {
            case .missingTitle:
                return "Title is required."
            case .titleTooLong:
                return "Title length is max 35 characters."
            }
        }
}
