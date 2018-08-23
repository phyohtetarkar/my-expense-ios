//
//  ExpensesViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/14/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

fileprivate let reuseIdentifier = "cellExpense"

class ExpensesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    private lazy var fetchedResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "year", ascending: false),
            NSSortDescriptor(key: "month", ascending: false),
            NSSortDescriptor(key: "day", ascending: false)
        ]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()
    
    private var details: [ExpenseDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        do {
            try fetchedResultController.performFetch()
            
            details = ExpenseDataManager.toDetailList(expenses: fetchedResultController.fetchedObjects)
            calculateTotalExpense()
        } catch let error as NSError {
            fatalError(error.description)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ExpenseTableViewCell else {
            fatalError("Error reusing cell")
        }
        
        cell.bind(detail: details[indexPath.row])
        
        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        details = ExpenseDataManager.toDetailList(expenses: controller.fetchedObjects as? [Expense])
        tableView.reloadData()
        calculateTotalExpense()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "expenseDetail":
            guard let dest = segue.destination as? ExpenseDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? ExpenseTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            dest.detail = details[indexPath.row]
            
        default:
            break
        }
    }
    
    
    // MARK: - Private methods
    
    private func calculateTotalExpense() {
        if let amt = fetchedResultController.fetchedObjects?.map({ $0.amount }).reduce(0, +), amt > 0 {
            totalExpenseLabel.text = amt.asString()
        } else {
            totalExpenseLabel.text = "000"
        }
    }

}
