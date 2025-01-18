//
//  SharedContainer.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-11.
//

import Foundation
import SwiftData
//https://github.com/JuniperPhoton/Widget-Intermediate-Animation/blob/main/WidgetIntermediateAnimation/AppModelContainer.swift

var sharedModelContainer: ModelContainer = {

    let schema = Schema([
        TodoTask.self, CoffeeCup.self, Category2.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
