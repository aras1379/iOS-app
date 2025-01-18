//
//  FeedModel.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-14.
//

import Foundation
import Observation
import UIKit
import WidgetKit
import SwiftData
//https://pixabay.com/api/?key=42388309-41250768cc50ff9a2e164674f&q=yellow+flowers&image_type=photo&pretty=true

@Observable
class ImageModel{
    private let baseUrl = "https://pixabay.com/api/"
    private let apiKey = "42388309-41250768cc50ff9a2e164674f"
    var isLoading = false
    var imageData: ImageData?
    var images: [ImageData.ApiImage] = []
    private let downloadManager = ImageDownloadManager()
    
    func loadImages(searchWord: String) async throws {
        
        //https://developer.apple.com/documentation/swift/caseiterable
        
        //encoding the searchword
        let encodedWord = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let feedUrl = "\(baseUrl)?key=\(apiKey)&q=\(encodedWord)&image_type=illustration"
        
        guard let url = URL(string: feedUrl) else {
            print("URL Dont work")
            return
        }
        
        isLoading = true
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard response is HTTPURLResponse else{
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let imageResponse = try decoder.decode(ImageData.ApiResponse.self, from: data)
            DispatchQueue.main.async{
                self.images = imageResponse.hits
                self.isLoading = false
            }
        }
        catch {
            DispatchQueue.main.async{
                print("Failed to load images : \(error)")
            }
        }
        isLoading = false
        
    }
    
    func downloadImage(imageURL: String) async throws -> String {
        return try await downloadManager.downloadImage(imageURL: imageURL)
    }
    //https://chat.openai.com/share/0c4cd7b4-caae-4733-9152-7181a38daefe
    //https://medium.com/@alessandromanilii/download-images-in-swift-d3ba2d8ebc3d
    actor ImageDownloadManager{
        func downloadImage(imageURL: String) async throws -> String {
            guard let url = URL(string: imageURL) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            return saveImageLocally(image: image)
        }
        
        //https://www.hackingwithswift.com/forums/100-days-of-swiftui/day-72-project-14-bucketlist-unable-to-load-saved-data/10946
        nonisolated func saveImageLocally(image: UIImage) -> String{
            guard let imageData = image.jpegData(compressionQuality: 1) else {return "" }
            let fileName = String(UUID().uuidString.prefix(8))
            let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
            
            do {
                try imageData.write(to: filePath)
                return fileName
            } catch {
                print("Error saving img locally: \(error)")
                return ""
            }
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
