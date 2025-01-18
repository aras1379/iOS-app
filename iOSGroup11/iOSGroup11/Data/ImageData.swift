//
//  PatternData.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-14.
//

import Foundation

struct ImageData: Decodable {
    
    struct Image: Decodable {
        let id: String
    }
    
    let images: Image
    
    struct ApiResponse: Decodable{
        let total: Int
        let totalHits: Int
        let hits: [ApiImage]
    }
   
    struct ApiImage: Decodable{
        let id: Int
        let pageURL: String
        let type: String
        let tags: String
        let previewURL: String
        let webformatURL: String 
    }
}
