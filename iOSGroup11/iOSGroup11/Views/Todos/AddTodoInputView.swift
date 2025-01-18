//
//  AddTodoInputView.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-03-14.
//

import SwiftUI

struct AddTodoInputView: View {
    //I hope that I understand correctly that it is still okay to use binding and not just bindable, since they exists for different purposes.
    //Created this file to shorten code in AddTodosView.
    @Binding var titleInput: String
    @Binding var isPriority: Bool
    @Binding var showingDatePicker: Bool
    @Binding var currentDate: Date
    @Binding var selectedCategory: Category2?
    let categories: [Category2]
    
    var body: some View {
        VStack {
            TextField("Title", text: $titleInput)
                .padding()
                .textFieldStyle(.roundedBorder)
            
            HStack {
                Text("Category:")
                    .padding(.leading, 15)
                Spacer()
                Picker(selection: $selectedCategory, label: Text(selectedCategory?.title ?? "Select Category")) {
                    Text("No Category").tag(nil as Category2?)
                    ForEach(categories, id: \.id) { category in
                        Text(category.title).tag(category as Category2?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
            }
            Toggle("Priority", isOn: $isPriority)
                .padding()
            
            if showingDatePicker {
                DatePicker("Date", selection: $currentDate,
                           in: Date()...,
                           displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            }
            
            Button(action: {
                self.showingDatePicker.toggle()
            }) {
                Text(showingDatePicker ? "Hide Date" : "Select Date")
            }
        }
    }
}
