//
//  UIScalableProgressView.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/7/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class UIScalableProgressView: UIProgressView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.transform.scaledBy(x: 1, y: 12)
        
    }

}