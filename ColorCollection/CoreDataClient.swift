//
//  CoreDataClient.swift
//  ColorCollection
//
//  Created by Adland Lee on 9/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataClient {
    
    // MARK: - Properties
    var container: NSPersistentContainer! { get }
    var mainContext: NSManagedObjectContext { get }
    
    // MARK: - Methods
    
    func saveContext()
}
