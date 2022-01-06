//
//  RecipesOrganiserApp.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 6/1/22.
//

import SwiftUI

@main
struct RecipesOrganiserApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
