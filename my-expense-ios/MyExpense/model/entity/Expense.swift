//
//  Expense.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Expense: Object, PExpense {

    dynamic var id = 0
    dynamic var amount = 0.0
    dynamic var year = 2018
    dynamic var month = 1
    dynamic var day = 1
    dynamic var note = ""
    
    @objc dynamic var _category: Category?
    
    var category: PCategory? {
        
        get {
            return _category
        }
        
        set {
            _category = newValue as? Category
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
