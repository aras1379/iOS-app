//
//  TodosAllView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-02-22.
//

import SwiftUI
import SwiftData
import WidgetKit

struct AllTodosView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    
    @State private var isAddingTodo = false
    @State private var isEditTodo = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TodoFilteredView(viewModel: viewModel, modelContext: modelContext, todos: viewModel.todos)
            }
            .frame(maxHeight: .infinity)
            .listStyle(PlainListStyle())
            
            Spacer()
            //https://developer.apple.com/documentation/familycontrols/familyactivityiconview/navigationdestination(ispresented:destination:)?changes=latest_minor
                .navigationDestination(isPresented: $isAddingTodo) {
                    AddTodosView(viewModel: viewModel, modelContext: modelContext)
                }
            HStack(spacing: 20) {
                SmallerButton(title: "New Todo", action: {
                    isAddingTodo = true
                })
                .onTapGesture {
                    isAddingTodo = true
                }
                SmallerButton(title: "Delete Done Todos", action: {
                    viewModel.deleteAllDoneTodos()
                })
            }
            .padding()
        }
        .navigationTitle(isAddingTodo ? "Add todo" : "All Todos")
    }
}
