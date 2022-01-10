//
//  Recipe.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 6/1/22.
//

import CoreData

extension Recipe {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Recipe> {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func add(name: String, url: String, categoryName: String, in context: NSManagedObjectContext) {
        let recipe = Recipe(context: context)
        recipe.name = name
        recipe.url = url
        recipe.count = 0
        recipe.timestamp = Date()
        recipe.id = UUID()
        recipe.objectWillChange.send()
        recipe.category = Category.withName(categoryName, context: context)
        try? context.save()
        print("Recipe saved")
    }
}
