//
//  Color.swift
//  ColorCollection
//
//  Created by Jason on 4/7/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import CoreData

@objc(Color)

class Color: NSManagedObject {
    
    // Store UIColor values in this value attribute
    @NSManaged var value: UIColor
    
    convenience init(insertIntoMangedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Color.typeName, in: context)!
        self.init(entity: entity, insertInto: context)
        
        value = UIColor.white
    }
}
