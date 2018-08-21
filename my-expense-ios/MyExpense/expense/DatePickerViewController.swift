//
//  DatePickerViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/20/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setDate(currentDate, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
