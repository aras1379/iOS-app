//
//  TodoWidgetView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-09.
//

import SwiftUI
import SwiftData
import WidgetKit
import AppIntents

struct TodosWidgetView: View {
    let todos: [SimpleTodo] // Assuming SimpleTodo is your model

    var body: some View {
        VStack {
            Section(header: Text("PRIO").font(.headline)){
                
                ForEach(todos, id: \.id) { todo in
                    Text(todo.title)
                }
            }
        }
    }
}
//
//#Preview {
  //  TodoWidgetView()
//}
