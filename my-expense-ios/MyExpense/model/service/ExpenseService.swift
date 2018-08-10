//
//  ExpenseService.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation

protocol ExpenseService {
    
    associatedtype E: PExpense
    
    func findAll() -> [E]
    
    func getExpense(id: Int) -> E?
    
    func save(expense: E)
    
}
