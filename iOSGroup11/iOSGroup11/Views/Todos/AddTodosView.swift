//
//  AddTodosView.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-23.
//

import SwiftUI
import SwiftData

struct AddTodosView: View {
    let viewModel: StartPageView.ViewModel
    let modelContext: ModelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var titleInput = ""
    @State private var isPriority = false
    @State private var selectedCategory: Category2?
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var isDone = false
    @State private var showingDatePicker = false
    @State private var savedTodo = false
    @State private var showError = false
    let errorMessage: String = "Title can not be empty"
    var initialCategory: Category2?
    
    init(viewModel: StartPageView.ViewModel, modelContext: ModelContext, initialCategory: Category2? = nil) {
        self.viewModel = viewModel
        self.modelContext = modelContext
        self.initialCategory = initialCategory
        _selectedCategory = State(initialValue: initialCategory)
    }
    
    var body: some View {
        VStack {
            AddTodoInputView(titleInput: $titleInput, isPriority: $isPriority, showingDatePicker: $showingDatePicker, currentDate: $currentDate, selectedCategory: $selectedCategory, categories: viewModel.categories)
            
            Spacer()
            
            SmallerButton(title: "Save", action: {
                savedTodo = true
                
                if titleInput.isEmpty {
                    showError = true
                    return
                }
                let newTodo = viewModel.addTodo(title: titleInput, isPrio: isPriority, isDone: isDone, date: showingDatePicker ? currentDate : selectedDate)
                
                if let categoryS = selectedCategory {
                    viewModel.addTodoToCategory(todo: newTodo, category: categoryS)
                }
                viewModel.updateFillLevel()
                dismiss()
            })
            .padding()
        }
        .navigationTitle("Add Todo")
        .alert(errorMessage,
               isPresented: $showError) {
            Button("OK", role: .cancel) {}
        }
               .onChange(of: showingDatePicker) {_, newValue in
                   if newValue {
                       currentDate = Date()
                   }
               }
    }
}
