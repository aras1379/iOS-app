//
//  Protocols.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-13.
//

import Foundation
import SwiftData
import UIKit

protocol FileManagerProtocol {
    func saveImage(_ image: UIImage, withFileName fileName: String) throws -> URL
    func deleteImage(withFileName fileName: String) throws
}

extension FileManager: FileManagerProtocol {
    func saveImage(_ image: UIImage, withFileName fileName: String) throws -> URL {
        let directory = urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            try data.write(to: fileURL)
            return fileURL
        } else {
            throw NSError(domain: "com.example.YourApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to save image"])
        }
    }
    
    func deleteImage(withFileName fileName: String) throws {
        let directory = urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(fileName)
        
        if fileExists(atPath: fileURL.path) {
            try removeItem(at: fileURL)
        }
    }
}
protocol ImageHandling {
    func downloadImage(imageURL: String) async throws -> String
}


extension ImageModel: ImageHandling {}





