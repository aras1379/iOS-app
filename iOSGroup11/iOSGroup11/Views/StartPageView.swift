//
//  StartPageView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-02-14.
//

import SwiftUI
import SwiftData
import AppIntents

struct StartPageView: View {
    @State private var viewModel: ViewModel
    @State var modelContext: ModelContext    
    @State private var buttonAllTodos = false
    @State private var buttonCategories = false
    @State private var isAddingTodo = false
    @State private var buttonTimer = false

    var body: some View {
        VStack {
            NavigationStack {
                CoffeeCupView(viewModel: viewModel, modelContext: modelContext)
                Spacer()
                
                Spacer()
                HStack(spacing: 35){
                    Spacer()
                    VStack() {
                        CommonButton(title: "All Todos", action: { buttonAllTodos = true })
                        CommonButton(title: "New Todo", action: {isAddingTodo = true})
                    }
                    VStack(){
                        CommonButton(title: "Categories", action: {buttonCategories = true})
                        CommonButton(title: "Timer", action: {buttonTimer = true})
                    }
                    Spacer()
                }
                .navigationTitle("Time Manager")
               
                Spacer()
                .navigationDestination(isPresented: $buttonAllTodos) {
                    AllTodosView(viewModel: viewModel, modelContext: modelContext)
                }
                .navigationDestination(isPresented: $buttonCategories) {
                    AllCategoriesView(viewModel: viewModel, modelContext: modelContext)
                }
                .navigationDestination(isPresented: $isAddingTodo) {
                    AddTodosView(viewModel: viewModel, modelContext: modelContext)
                }
                .navigationDestination(isPresented: $buttonTimer){
                    TimerView()
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    init(modelContext: ModelContext) {
        self._modelContext = State(initialValue: modelContext)
        let imageModel = ImageModel()
        let viewModel = ViewModel(modelContext: modelContext, imageHandler: imageModel)
        
        self._viewModel = State(initialValue: viewModel)
    }
}
