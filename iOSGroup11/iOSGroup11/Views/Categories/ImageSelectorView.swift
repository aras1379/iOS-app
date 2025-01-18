//
//  ImageSelectorView.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-06.
//

import SwiftUI

struct ImageSelectorView: View {
    var imageModel: ImageModel
    var showImages: (String) -> Void
    var searchWord: String
    var body: some View {
        ScrollView {
            VStack {
                ForEach(imageModel.images, id: \.id) { image in
                    Button(action: {
                        showImages(image.webformatURL)
                    }) {
                        AsyncImage(url: URL(string: image.previewURL)) { img in
                            switch img {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .scaledToFit()
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: 250)
                    }
                }
            }
            .onAppear {
                Task {
                    try? await imageModel.loadImages(searchWord: searchWord)
                }
            }
        }
        .padding()
        .background(.white)
        .border(.green, width: 2)
    }
}
