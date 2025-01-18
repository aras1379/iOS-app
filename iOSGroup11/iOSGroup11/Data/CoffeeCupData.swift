//
//  CoffeeCupData.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-09.
//


import Foundation
import SwiftData
import AppIntents

@Model
final class CoffeeCup: Identifiable{
    @Attribute(.unique) var id: String = UUID().uuidString
        var fillLevel: Int
        
    init(fillLevel: Int) {
        self.fillLevel = fillLevel
    }
}
