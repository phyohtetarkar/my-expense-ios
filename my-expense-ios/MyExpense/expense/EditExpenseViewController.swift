//
//  EditExpenseViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/14/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

class EditExpenseViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    @IBOutlet weak var expenseDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    private var sectionCount = 5
    private var category: Category? = nil
    private var date = Date()
    
    private lazy var bottomSheetTransitionDelegate = { BottomSheetPresentationManager(height: 261) }()
    
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
            
            date = e.toDate()!
            category = e.category
        } else {
            sectionCount = 4
            expenseDateLabel.text = date.appDefaultFormat()
        }
        
        titleTextField.delegate = self
        amountTextField.delegate = self
        
        validate()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TextField action
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.section == 4 {
            tableView.deselectRow(at: indexPath, animated: true)
            let alert = UIAlertController(title: "Are you sure to delete expense \"\(expense!.title!)\"?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] action in
                self.context.delete(self.expense!)
                do {
                    try self.context.save()
                    self.navigationController?.popViewController(animated: true)
                } catch let error as NSError {
                    self.context.rollback()
                    print("Error deleting expense: \(error)")
                }
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "dateSheet":
            guard let nav = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let dest = nav.topViewController as? DatePickerViewController else {
                fatalError("Unexpected destination: \(nav)")
            }
            
            nav.modalPresentationStyle = .custom
            nav.transitioningDelegate = bottomSheetTransitionDelegate
            
            dest.currentDate = date

        default:
            break
        }
    }
    
    
    @IBAction func unwindToEditExpense(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CategorySelectionViewController, let indexPath = sourceViewController.tableView.indexPathForSelectedRow {
            let selected = sourceViewController.fetchedResultController.object(at: indexPath)
            self.category = selected
            categoryLabel.text = selected.name
            validate()
        } else if let sourceViewController = sender.source as? DatePickerViewController {
            let date = sourceViewController.datePicker.date
            expenseDateLabel.text = date.appDefaultFormat()
            self.date = date
        }
    }
    
    @IBAction func saveExpense(_ sender: UIBarButtonItem) {
        
        if expense == nil {
            expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as? Expense
            expense?.createdAt = Date()
        }
        
        do {
            expense?.title = titleTextField.text
            expense?.amount = Double(amountTextField.text ?? "0.0")!
            expense?.note = noteTextField.text
            expense?.category = category
            expense?.setDate(date: date)
            
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
    
    private func validate() {
        guard let title = titleTextField.text, !title.isEmpty else {
            saveButton.isEnabled = false
            return
        }
        
        guard let amt = amountTextField.text, !amt.isEmpty else {
            saveButton.isEnabled = false
            return
        }
        
        guard let _ = category else {
            saveButton.isEnabled = false
            return
        }
        
        saveButton.isEnabled = true
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
