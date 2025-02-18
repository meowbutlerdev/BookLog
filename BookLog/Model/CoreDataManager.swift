//
//  CoreDataManager.swift
//  BookLog
//
//  Created by 박지성 on 2/14/25.
//

import CoreData
import os

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookLog")
        container.loadPersistentStores { _, error in
            if let error = error {
                os_log("Persistent store loading failed: %{public}@", type: .error, error.localizedDescription)
            }
        }
        return container
    }()

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            os_log("Failed to save context: %{public}@", type: .error, error.localizedDescription)
        }
    }
}
