//
//  PExpense.swift
//  MyExpense
//
//  Created by OP-Macmini3 on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import Foundation

protocol PExpense {
    
    var id: Int { get set }
    var amount: Double { get set }
    var year: Int { get set }
    var month: Int { get set }
    var day: Int { get set }
    var note: String { get set }
    
    var category: PCategory? { get set }
    
}
