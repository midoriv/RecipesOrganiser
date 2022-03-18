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
}
