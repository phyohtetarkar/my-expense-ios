//
//  BasicTableViewCell.swift
//  MyExpense
//
//  Created by OP-Macmini3 on 8/16/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UILabel!    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}