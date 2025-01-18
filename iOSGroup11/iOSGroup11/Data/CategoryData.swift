//
//  CategoryData.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-04.
//

import Foundation
import SwiftData
import WidgetKit

@Model
final class Category2: Identifiable{
    @Attribute(.unique) let id = UUID().uuidString
    var title: String
    var imageId: String?
    var todos: [TodoTask] = [] 
    
    init(title: String, imageId: String? = nil) {
        self.title = title
        self.imageId = imageId
    }
}
