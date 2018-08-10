//
//  CategoryService.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation

protocol CategoryService {
    
    associatedtype E: PCategory
    
    func findAll() -> [E]
    
    func findAllWithAmount() -> [E]
    
    func getCategory(id: Int) -> E?
    
    func save(category: E)
    
}
