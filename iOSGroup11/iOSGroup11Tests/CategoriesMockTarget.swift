//
//  CategoriesMockTarget.swift
//  iOSGroup11Tests
//
//  Created by Sara Ljung on 2024-03-11.
//

import Foundation
@testable import iOSGroup11
import UIKit

class MockImageModel: ImageHandling {
    func downloadImage(imageURL: String) async throws -> String {
        return "path/to/mockImage.jpg"
    }
}

class MockFileManager: FileManagerProtocol {
    var mockImageSavePath: URL?
    var filesToRemove: [String] = []
    var existingFiles: [String] = []

    func saveImage(_ image: UIImage, withFileName fileName: String) throws -> URL {
        let mockURL = URL(fileURLWithPath: "path/to/\(fileName).jpg")
        mockImageSavePath = mockURL
        return mockURL
    }

    func deleteImage(withFileName fileName: String) throws {
        filesToRemove.append(fileName)
    }

    func fileExists(atPath path: String) -> Bool {
        return existingFiles.contains(path)
    }
}
