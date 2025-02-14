//
//  CoreDataManager.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookLog")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
