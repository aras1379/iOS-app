//
//  iOSGroup11App.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-13.
//
import WidgetKit
import SwiftUI
import SwiftData

@main
struct iOSGroup11App: App {
    
    //   init(){
    //     configureSwiftData()
    //}
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Category2.self, TodoTask.self, CoffeeCup.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
    }
    
    
}
    //https://www.hackingwithswift.com/quick-start/swiftdata/how-to-access-a-swiftdata-container-from-widgets
    /*func configureSwiftData(){
        let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConfig.Group11AppSharedStorage)
        let databaseURL = sharedContainerURL?.appendingPathComponent(<#T##partialName: String##String#>, conformingTo: <#T##UTType#>)
    }*/

