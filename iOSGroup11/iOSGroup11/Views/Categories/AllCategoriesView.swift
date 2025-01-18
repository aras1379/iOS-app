//
//  CategoriesScreen.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-14.
//

import SwiftUI
import UIKit
import SwiftData
import WidgetKit

struct AllCategoriesView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(viewModel.categories){ category in
                    let uiImage: UIImage? = category.imageId != nil ? viewModel.loadImage(fromImageId: category.imageId!) : nil
                    ZStack {
                        Group {
                            if let uiImage = uiImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Color.gray.opacity(0.2)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        
                        NavigationLink(destination: CategoryDetailView(viewModel: viewModel, modelContext: modelContext, category: category)) {
                            Text(category.title)
                                .font(.title)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .background(.white.opacity(0.5))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(height: 60)
                    .cornerRadius(10)
                    .listRowInsets(EdgeInsets())
                    .padding(2)
                }
                .onDelete(perform: viewModel.deleteCategory(at:))
                
                .listStyle(PlainListStyle())
                .navigationTitle("Categories")
                
                NavigationLink(destination: AddCategoryView(viewModel: viewModel, modelContext: modelContext)){
                    Text("Add Category")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                        .font(.headline)
                }
                .buttonCommonGreen()
            }
        }
    }
}
