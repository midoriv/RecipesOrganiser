//
//  Category.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 6/1/22.
//

import CoreData

extension Category {
    // Get all categories
    static func allCategories(in context: NSManagedObjectContext) -> [Category] {
        let request = fetchRequest(NSPredicate(format: "TRUEPREDICATE"))
        return (try? context.fetch(request)) ?? []
    }
    
    static func categoriesCount(context: NSManagedObjectContext) -> Int {
        let request = fetchRequest(NSPredicate(format: "TRUEPREDICATE"))
        let categories = (try? context.fetch(request)) ?? []
        return categories.count
    }
    
    static func deleteAll(context: NSManagedObjectContext) {
        let request = fetchRequest(NSPredicate(format: "TRUEPREDICATE"))
        let categories = (try? context.fetch(request)) ?? []
        for category in categories {
            context.delete(category)
        }
        try? context.save()
        print("Deleted all categories")
    }
    
    // find a Category with a given name
    static func withName(_ name: String, context: NSManagedObjectContext) -> Category? {
        let request = fetchRequest(NSPredicate(format: "name_ = %@", name))
        let category = (try? context.fetch(request)) ?? []
        return category.first
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Category> {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func add(name: String, in context: NSManagedObjectContext) {
        let category = Category(context: context)
        category.name = name
        category.id = UUID()
        category.objectWillChange.send()
        category.recipes.forEach { $0.objectWillChange.send() }
        try? context.save()
    }
    
    // Delete a category at the given offsets
    static func delete(at offsets: IndexSet, in context: NSManagedObjectContext) -> Bool {
        let all = allCategories(in: context)
        if !all.isEmpty {
            for index in offsets {
                let toDelete = all[index]
                
                // if there exists a recipe that falls under this category
                if toDelete.recipes.count == 0 {
                    context.delete(toDelete)
                    try? context.save()
                    print("Category deleted.")
                    return true
                }
            }
        }
        return false
    }
    
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var recipes: Set<Recipe> {
        get { (recipes_ as? Set<Recipe>) ?? [] }
        set { recipes_ = newValue as NSSet }
    }
 }

