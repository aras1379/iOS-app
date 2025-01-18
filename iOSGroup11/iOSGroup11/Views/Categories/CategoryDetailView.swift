//  CategoryDetailView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-02-20.
//

import SwiftUI
import SwiftData
import WidgetKit

struct CategoryDetailView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    var category: Category2
    @State private var isAddingTodo = false
    
    var body: some View {
        //https://chat.openai.com/share/ff66eedb-567d-4763-a14e-a27f7afdf5dd
        let uiImage: UIImage? = category.imageId != nil ? viewModel.loadImage(fromImageId: category.imageId!) : nil
        let filterTodos = viewModel.todosFiltered(forCategory: category)
        
        VStack{
            TodoFilteredView(viewModel: viewModel, modelContext: modelContext, todos: filterTodos)
                .padding()
                .navigationTitle(category.title)
            Spacer()
                .navigationDestination(isPresented: $isAddingTodo) {
                    AddTodosView(viewModel: viewModel, modelContext: modelContext)
                }
            HStack{
                SmallerButton(title: "New Todo", action: {
                    isAddingTodo = true
                })
                
                .buttonStyle(.bordered)
                .padding()
                .onTapGesture {
                    isAddingTodo = true
                }
                
                SmallerButton(title: "Delete all Done todoo", action: {
                    viewModel.deleteAllDoneTodos(in: category)
                })
                .buttonStyle(.bordered)
                .padding()
            }
            NavigationLink(destination: EditCategoryView(viewModel: viewModel, modelContext: modelContext, category: category)){
                Text("Edit Category")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                    .font(.headline)
            }
            .buttonCommonStyle()
            .padding()
        }
        .background(
            Group {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.bottom)
                } else {
                    Color.gray.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        )
    }
}
