//
//  TypeName+Extensions.swift
//  ColorCollection
//
//  Created by Adland Lee on 9/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

protocol TypeName: AnyObject {
    static var typeName: String { get }
}

extension TypeName {
    static var typeName: String {
        return String(describing: self)
    }
}

extension NSObject: TypeName {
    class var typeName: String {
        return String(describing: self)
    }
}
