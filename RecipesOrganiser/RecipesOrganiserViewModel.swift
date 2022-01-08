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
        else {
            print("Categories have already been loaded")
            
            // delete all
//            Category.deleteAll(context: context)
        }
    }
    
    private func loadDefaultCategories() {
        print ("Load built-in categories")
        let categoryNames = [
            "Breakfast", "Brunch", "Lunch", "Dinner", "Snacks", "Appetisers", "Soups", "Salads", "Sides", "Pizza", "Pasta",
            "Noodles", "Rice"
        ]
        
        for (index, name) in categoryNames.enumerated() {
            Category.add(name: name, id: index, in: context)
        }
    }
}

