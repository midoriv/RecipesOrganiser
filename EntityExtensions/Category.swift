//
//  Category.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 6/1/22.
//

import CoreData

extension Category {
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
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Category> {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func add(name: String, id: Int, in context: NSManagedObjectContext) {
        let category = Category(context: context)
        category.name = name
        category.id = Int16(id)
        category.objectWillChange.send()
        category.recipes.forEach { $0.objectWillChange.send() }
        
        try? context.save()
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

