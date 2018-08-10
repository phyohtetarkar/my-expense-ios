//
//  ExpenseServiceImpl.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation
import RealmSwift

class ExpenseServiceImpl: ExpenseService {

    private let realm = try! Realm()
    
    typealias E = Expense
    
    func findAll() -> [Expense] {
        return [Expense](realm.objects(Expense.self))
    }
    
    func getExpense(id: Int) -> Expense? {
        return realm.object(ofType: Expense.self, forPrimaryKey: id)
    }
    
    func save(expense: Expense) {
        try! realm.write {
            realm.add(expense, update: true)
        }
    }
    
}
