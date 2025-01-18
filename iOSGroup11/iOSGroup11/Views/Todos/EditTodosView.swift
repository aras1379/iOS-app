//
//  EditTodosView.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-03-06.
//

import SwiftUI
import SwiftData

struct EditTodosView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var todo: TodoTask
    
    @State private var showingDatePicker = false
    @State private var showError = false
    let errorMessage: String = "Title can not be empty"
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Title", text: $todo.title)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Text("Category:")
                        .padding(.leading, 15)
                    Spacer()
                    Picker(selection: $todo.category, label: Text("Category")) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category.title).tag(category as Category2?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }
                Toggle("Priority", isOn: $todo.isPrio)
                    .padding()
                
                //I had problems with making the date be updated for the edited todo, so chatGPT helped with that
                //https://chat.openai.com/share/b07b40dc-ad33-4960-9ae9-7471b57db06c
                if showingDatePicker {
                    DatePicker("Date", selection: Binding(
                        get: { todo.date ?? Date() },
                        set: { newValue in
                            todo.date = newValue }
                    ), in: Date()..., displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                }
            }
            Button(action: {
                showingDatePicker.toggle()
            }) {
                Text(showingDatePicker ? "Hide Date" : "Select Date")
            }
            Spacer()
            
            VStack {
                SmallerButton(title: "Save", action: {
                    if todo.title.isEmpty {
                        showError = true
                    } else {
                        if !showingDatePicker {
                            todo.date = nil
                        }
                        dismiss()
                    }
                })
                .alert(errorMessage,
                       isPresented: $showError) {
                    Button("OK", role: .cancel) {}
                }
                       .onChange(of: showingDatePicker) {_, newValue in
                           if newValue {
                               todo.date = Date()
                           }
                       }
            }
            .padding()
        }
        .navigationTitle("Edit Todo")
    }
}
