//
//  EditCategoryView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-02-27.
//


import SwiftUI
import SwiftData
struct EditCategoryView: View {
    let viewModel: StartPageView.ViewModel
    @State var modelContext: ModelContext
    @State private var imageModel = ImageModel()
    @State private var selectedImageURL: String?
    @Bindable var category: Category2
    @State private var showImages = false
    
    var body: some View {
        let uiImage: UIImage? = category.imageId != nil ? viewModel.loadImage(fromImageId: category.imageId!) : nil
        VStack{
            TextField("Title", text: $category.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Select Image"){
                showImages.toggle()
            }
            .padding()
            .background(Color.green.opacity(0.6))
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if showImages{
                ImageSelectorView(
                    imageModel: imageModel, showImages: { imageURL in
                        selectedImageURL = imageURL
                    },
                    searchWord: "pattern+background"
                )
            }
            Spacer()
            Button("Update") {
                Task{
                    guard let imageURL = selectedImageURL, !imageURL.isEmpty else { return }
                    do {
                        try await viewModel.updateCategory(category: category,  newImageURL: imageURL, currentImageURL: category.imageId)
                        
                    } catch {
                        print("Error updating category: \(error)")
                    }
                }
            }
            
            .padding()
            .buttonStyle(.borderedProminent)
            
        }
        .navigationTitle("Edit category")
        .background(Group {
            Group {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage).resizable().scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.gray.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        })
    }
}
