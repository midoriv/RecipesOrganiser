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
            NavigationView {
                RecipesView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(RecipesOrganiserViewModel(context: persistenceController.container.viewContext))
            }
        }
    }
}
