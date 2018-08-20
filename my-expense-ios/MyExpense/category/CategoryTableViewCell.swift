//
//  CategoryTableViewCell.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/13/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIRoundedView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(category: Category?) {
        if let c = category {
            let today = Date()
            let year = Calendar.current.component(.year, from: today)
            let month = Calendar.current.component(.month, from: today)
            
            let amount = c.expenses?.map({ $0 as! Expense }).filter({ exp in
                return Int(exp.year) == year && Int(exp.month) == month
            }).map({ $0.amount }).reduce(0, +)
            
            nameLabel.text = c.name
            
            if let amt = amount, amt > 0 {
                amountLabel.text = amt.asString()
            }
            
            colorView.backgroundColor = CATEGORYCOLORS[Int(c.color)]
        }
    }

}
