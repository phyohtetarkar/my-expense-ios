//
//  ExpenseTableViewCell.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/14/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(detail: ExpenseDetail) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        
        textLabel?.text = formatter.string(from: detail.date)
        detailTextLabel?.text = detail.amount.asString()
    }

}
