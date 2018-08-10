//
//  Category.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Category: Object, PCategory {
    
    dynamic var id = 0
    dynamic var name = ""
    
    dynamic var amount = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["amount"]
    }
    
}
