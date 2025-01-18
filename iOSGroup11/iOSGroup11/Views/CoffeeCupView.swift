//
//  CoffeeCupView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-04.
//

import SwiftUI
import SwiftData

//https://chat.openai.com/share/2e11bfa2-ce8b-468d-a5ce-70ce1a13611e
struct CoffeeCupView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext

    @State private var fillLevel = 0
    @State private var totalHeights = 14
   
    var body: some View {
        NavigationStack {
            VStack{
                List{
                    Section(header: Text("PRIO")){
                        ForEach(viewModel.todos.filter{$0.isPrio}){ todo in
                            NavigationLink (destination: EditTodosView(viewModel: viewModel, modelContext: modelContext, todo: todo)) {
                                HStack {
                                    Text(todo.title)
                                    Spacer()
                                    Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(todo.isDone ? .green : .red)
                                        .onTapGesture {
                                            viewModel.toggleIsDone(todo: todo)
                                        }
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            let filteredTodos = viewModel.todos.filter { $0.isPrio }
                            let todosToDelete = indexSet.map { filteredTodos[$0] }
                            todosToDelete.forEach { todoToDelete in
                                viewModel.deleteTodo(todoToDelete)
                            }
                        })
                    }
                }
                .frame(height: 200)
                
                Image(viewModel.coffeeImageName(for: viewModel.fillLevel))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250, alignment: .center)
            }
            .onAppear {
                viewModel.fetchCurrentFillLevel()
            }
        }
    }
}

