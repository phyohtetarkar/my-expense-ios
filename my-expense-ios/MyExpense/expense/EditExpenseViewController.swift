//
//  EditExpenseViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/14/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

class EditExpenseViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var expenseDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    private var sectionCount = 5
    
    var expense: Expense? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        
        if let e = expense {
            titleTextField.text = e.title
            amountTextField.text = e.amount.asString()
            expenseDateLabel.text = e.toDate()?.appDefaultFormat()
            noteTextField.text = e.note
            categoryLabel.text = e.category?.name
        } else {
            let today = Date()
            sectionCount = 4
            
            expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as? Expense
            expense?.createdAt = today
            expense?.setDate(date: today)
            expenseDateLabel.text = today.appDefaultFormat()
        }
        
        self.transitioningDelegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomHeightPresentationController(presentedViewController: presented, presenting: presenting, height: 261)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToEditExpense(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CategorySelectionViewController, let indexPath = sourceViewController.tableView.indexPathForSelectedRow {
            let selected = sourceViewController.fetchedResultController.object(at: indexPath)
            expense?.category = selected
            categoryLabel.text = selected.name
        } else if let sourceViewController = sender.source as? DatePickerViewController {
            let date = sourceViewController.datePicker.date
            expenseDateLabel.text = date.appDefaultFormat()
            expense?.setDate(date: date)
        }
    }
    
    @IBAction func saveExpense(_ sender: UIBarButtonItem) {
        
        do {
            expense?.title = titleTextField.text
            expense?.amount = Double(amountTextField.text ?? "0.0")!
            expense?.note = noteTextField.text
            
            try context.save()
            cancel(sender)
        } catch let error as NSError {
            context.rollback()
            print("Error saving expense: \(error)")
        }
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingModal = presentingViewController is UITabBarController
        
        if isPresentingModal {
            dismiss(animated: true, completion: nil)
        } else if let nav = navigationController {
            nav.popViewController(animated: true)
        }
    }
}

class CustomHeightPresentationController: UIPresentationController {
    
    private var height: CGFloat
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        self.height = height
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let size = containerView?.bounds else {
            fatalError()
        }
        return CGRect(x: size.height - height, y: 0.0, width: size.width, height: height)
    }
    
}

extension Expense {
    
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: "\(year)/\(month)/\(day)")
    }
    
    func setDate(date: Date) {
        let comp = date.toComponent()
        self.year = Int16(comp.0)
        self.month = Int16(comp.1)
        self.day = Int16(comp.2)
    }
    
}
