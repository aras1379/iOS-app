//
//  ContentView.swift
//  iOSGroup11
//
//  Created by Jenny Gran on 2024-02-13.
//

import SwiftUI
import SwiftData

// https://appmakers.dev/swiftui-environment/
struct ContentView: View {

   // @State private var todoViewModel: TodoViewModel
    //@State private var categoriesViewModel: CategoriesViewModel
    var modelContext: ModelContext
    var body: some View {
        
        

        StartPageView(modelContext: modelContext)
            
    }
    init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
}


    //Problem connection local endpoint???? :
    // https://forums.developer.apple.com/forums/thread/741207 
    

