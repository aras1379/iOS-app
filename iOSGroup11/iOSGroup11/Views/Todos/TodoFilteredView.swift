//
//  TodoFilteredView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-08.
//

import SwiftUI
import SwiftData

struct TodoFilteredView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    var todos: [TodoTask]
    
    var sortedUpcomingTodos: [TodoTask] {
        StartPageView.ViewModel.sortUpcomingTodos(viewModel.filteredTodos(for: .Upcoming))
    }
    
    @State private var selectedTimeFrame: TimeFrame = .Today
    var body: some View {
        VStack {
            Picker("TimeFrame", selection: $selectedTimeFrame) {
                ForEach(TimeFrame.allCases) { timeFrame in
                    Text(timeFrame.rawValue)
                        .tag(timeFrame)
                }
            }
            .pickerStyle(.segmented)
            
            List {
                ForEach(todos) { todo in
                    if todo.timeFrame == selectedTimeFrame {
                        NavigationLink(destination: EditTodosView(viewModel: viewModel, modelContext: modelContext, todo: todo)) {
                            VStack(alignment: .leading, spacing: 5) {
                                TaskView(viewModel: viewModel, modelContext: modelContext, todo: todo)
                                if let date = todo.date {
                                    Text(viewModel.dateFormatter.string(from: date))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    let todosToDelete = indexSet.map { index in
                        selectedTimeFrame == .Upcoming ? sortedUpcomingTodos[index] : viewModel.filteredTodos(for: selectedTimeFrame)[index]
                    }
                    todosToDelete.forEach(viewModel.deleteTodo)
                })
            }
        }
    }
}
