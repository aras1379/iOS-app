//
//  AddCategoryView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-02-20.
//

import SwiftUI
import SwiftData
struct AddCategoryView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    @Environment(\.dismiss) private var dismiss
    @State private var imageModel = ImageModel()
    @State private var showImages = false
    @State private var categoryTitle = ""
    @State private var selectedImageURL: String?
    @State private var showError = false
    
    var body: some View {
        VStack{
            TextField("Category title", text: $categoryTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            if let errorMessage = viewModel.errorMessage{
                Text(errorMessage)
                    .foregroundColor(.red)
            }
    
            Button("Select Image"){
                showImages.toggle()
            }
            .frame(maxWidth: .infinity)
            .buttonCommonGreen()
            .padding()

            if showImages{
                ImageSelectorView(
                    imageModel: imageModel, showImages: { imageURL in
                        selectedImageURL = imageURL
                    }, searchWord: "pattern+background"
                )
            }
            Spacer()
            
            Button("Save"){
                Task {
                    await viewModel.saveCategory(title: categoryTitle, imageURL: selectedImageURL ?? "")
                    dismiss()
                }
            }
            .frame(maxWidth: .infinity)
            .buttonCommonGreen()
            .padding()
        }
        .navigationTitle("Add Category")
    }
}
