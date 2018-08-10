//
//  CategoryServiceImpl.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
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
    
    func findAllWithAmount() -> [Category] {
        let categories = [Category](realm.objects(Category.self))
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        
        for c in categories {
            c.amount = realm.objects(Expense.self)
                .filter("year = %@ AND month = %@ and category.id = %@", components.year!, components.month!, c.id)
                .map({ $0.amount })
                .reduce(0, +)
        }
        
        return categories
    }
    
    func getCategory(id: Int) -> Category? {
        return realm.object(ofType: Category.self, forPrimaryKey: id)
    }
    
    func save(category: Category) {
        category.id = Date().millisecondsSince1970
        try! realm.write {
            realm.add(category, update: true)
        }
    }
    
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
