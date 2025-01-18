//
//  TaskView.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-03-06.
//

import SwiftUI
import SwiftData
import WidgetKit

//from lecture since my previous togglefunction did not work after implementing swiftdata
struct TaskView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    
    let todo: TodoTask
    
    var body: some View {
        HStack {
            Image(systemName: todo.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.isDone ? .green : .red)
            Text(todo.title)
            Spacer()
        }
        .onTapGesture {
            viewModel.toggleIsDone(todoID: todo.id)
            viewModel.sortTodos()
        }
    }
}
