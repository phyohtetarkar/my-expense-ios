//
//  Expense.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation
import RealmSwift

class Expense: Object, PExpense {

    @objc dynamic var id = 0
    @objc dynamic var amount = 0.0
    @objc dynamic var year = 2018
    @objc dynamic var month = 1
    @objc dynamic var day = 1
    @objc dynamic var note = ""
    
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
