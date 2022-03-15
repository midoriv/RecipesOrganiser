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
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    // Get all recipes
    static func allRecipes(in context: NSManagedObjectContext) -> [Recipe] {
        let request = fetchRequest(NSPredicate(format: "TRUEPREDICATE"))
        return (try? context.fetch(request)) ?? []
    }
    
    // Find a Recipe with a given id
    static func withId(_ id: UUID, in context: NSManagedObjectContext) -> Recipe? {
        let request = fetchRequest(NSPredicate(format: "id = %@", id as CVarArg))
        let recipe = (try? context.fetch(request)) ?? []
        return recipe.first
    }
    
    static func update(id: UUID, name: String, url: String, categoryName: String, in context: NSManagedObjectContext) {
        if let recipe = withId(id, in: context) {
            recipe.name = name
            recipe.url = url
            recipe.timestamp = Date()
            if let category = Category.withName(categoryName, context: context) {
                recipe.category = category
            }
            try? context.save()
            print("Recipe updated")
        }
    }
    
    static func add(name: String, url: String, categoryName: String, in context: NSManagedObjectContext) {
        let recipe = Recipe(context: context)
        recipe.name = name
        recipe.url = url
        recipe.count = 0
        recipe.timestamp = Date()
        recipe.id = UUID()
        if let category = Category.withName(categoryName, context: context) {
            recipe.category = category
        }
        try? context.save()
        print("Recipe saved")
    }
    
    static func delete(at offsets: IndexSet, in context: NSManagedObjectContext) {
        for index in offsets {
            let all = allRecipes(in: context)
            if !all.isEmpty {
                let recipe = all[index]
                context.delete(recipe)
                try? context.save()
                print("recipe deleted")
            }
        }
    }
    
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var url: String {
        get { url_ ?? "" }
        set { url_ = newValue }
    }
    
    var timestamp: Date {
        get { timestamp_! }
        set { timestamp_ = newValue }
    }
    
    var category: Category {
        get { category_! }
        set { category_ = newValue }
    }
}
