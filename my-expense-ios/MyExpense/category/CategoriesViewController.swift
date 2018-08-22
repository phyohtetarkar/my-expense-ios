//
//  CategoriesViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/13/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

fileprivate let reuseIdentifier = "cellCategory"
fileprivate let segueIdentifier = "editCategory"

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    
    private lazy var categoryResultController: NSFetchedResultsController<Category> = {
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()
    
    private lazy var expenseResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        let comp = Date().toComponent()
        
        let yearPred = NSPredicate(format: "year == %i", comp.0)
        let monthPred = NSPredicate(format: "month == %i", comp.1)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPred, monthPred])
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try categoryResultController.performFetch()
            try expenseResultController.performFetch()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM, yyyy"
            
            monthYearLabel.text = formatter.string(from: date)
            
            reloadTotalAmount()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryResultController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("Error reusing cell")
        }
        
        let category = categoryResultController.object(at: indexPath)
        cell.bind(category: category)

        return cell
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        reloadTotalAmount()
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case segueIdentifier:
            guard let dest = segue.destination as? EditCategoryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? CategoryTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let category = categoryResultController.object(at: indexPath)
            dest.title = "Edit Category"
            dest.category = category
            
        default:
            break
        }
    }
    
    
    // MARK: - Private methods
    
    private func reloadTotalAmount() {
        if let amt = expenseResultController.fetchedObjects?.map({ $0.amount }).reduce(0, +), amt > 0 {
            expenseAmountLabel.text = amt.asString()
        } else {
            expenseAmountLabel.text = "000"
        }
    }

}
