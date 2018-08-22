//
//  UIRoundedButton.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/8/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class UICircleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = max(bounds.width, bounds.height) / 2
        self.layer.masksToBounds = true
        
    }

}
