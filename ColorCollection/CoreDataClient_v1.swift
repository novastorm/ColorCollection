//
//  CoreDataClient_v1.swift
//  ColorCollection
//
//  Created by Adland Lee on 9/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import CoreData
import UIKit

final class CoreDataClient_v1: CoreDataClient {
    
    // MARK: - Properties
    let container: NSPersistentContainer!    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: - Initializers
    
    init(container: NSPersistentContainer) {
        self.container = container
        loadPersistentStores()
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

    }
    
    // MARK: - Methods
    
    func saveContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            }
            catch {
                fatalError("Error while saving main context \(error)")
            }
        }
    }
    
    // MARK: - Helper Methods

    private func loadPersistentStores(completionsHandler: (() -> Void)? = nil) {
        container.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            completionsHandler?()
        }
    }
}
