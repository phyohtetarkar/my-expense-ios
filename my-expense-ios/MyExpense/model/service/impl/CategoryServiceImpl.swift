//
//  CategoryServiceImpl.swift
//  MyExpense
//
//  Created by OP-Macmini3 on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryServiceImpl: CategoryService {
    
    private let realm = try! Realm()
    
    typealias E = Category
    
    func findAll() -> [Category] {
        return [Category](realm.objects(Category.self))
    }
    
    func getCategory(id: Int) -> Category? {
        return realm.object(ofType: Category.self, forPrimaryKey: id)
    }
    
    func save(category: Category) {
        try! realm.write {
            realm.add(category, update: true)
        }
    }
    
}
