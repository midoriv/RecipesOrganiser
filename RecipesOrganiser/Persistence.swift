//
//  Persistence.swift
//  RecipesOrganiser
//
//  Created by Midori Verdouw on 6/1/22.
//

import CoreData

struct PersistenceController {
    private(set) var errorManager = ErrorManager()
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RecipesOrganiser")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        Task { [self] in
            self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if error != nil {
                    self.errorManager.errorOccurrence = true
                }
            })
        }
    }
}
