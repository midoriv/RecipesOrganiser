//
//  RecipesOrganiserViewModel.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 7/1/22.
//

import SwiftUI
import CoreData

class RecipesOrganiserViewModel: ObservableObject {
    let context: NSManagedObjectContext
    @Published var alertState = AlertState()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        // if categories have not been loaded (first time the app runs)
        if Category.categoriesCount(context: context) == 0 {
            loadDefaultCategories()
        }
    }
    
    private func loadDefaultCategories() {
        print("Load built-in categories")
        let categoryNames = ["Breakfast", "Dinner", "Appetisers", "Soups", "Salads", "Pasta"]
        
        for name in categoryNames {
            Category.add(name: name, in: context)
        }
    }
    
    // MARK: - Intents
    
    func resetAlertState() {
        alertState = AlertState()
    }
    
    func removeCategory(_ offsets: IndexSet) {
        // show alert if deletion failed
        alertState.deletionState = Category.delete(at: offsets, in: context)
        
        switch(alertState.deletionState) {
        // if deletion failed for any reason
        case .failedAsRecipeExists, .failedAsDeleteLast, .failedAsEmpty:
            alertState.deleteAlert = true
        default:
            alertState.deleteAlert = false
            alertState.deletionState = .idle
        }
    }
}
