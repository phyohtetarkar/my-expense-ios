//
//  AlertManager.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/23/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class AlertManager {
    
    static func info(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        return alert
    }
    
}
