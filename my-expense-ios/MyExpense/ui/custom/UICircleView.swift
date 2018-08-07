//
//  UIRoundCornerView.swift
//  MyExpense
//
//  Created by OP-Macmini3 on 8/7/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

@IBDesignable
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
        
        self.layer.cornerRadius = bounds.width / 2
        self.layer.masksToBounds = true
        
    }

}
