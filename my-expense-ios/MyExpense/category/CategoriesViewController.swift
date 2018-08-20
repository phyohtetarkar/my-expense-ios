//
//  CategoriesViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/13/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    
    private lazy var categoryResultController: NSFetchedResultsController<Category> = {
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    private lazy var expenseResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        let date = Date()
        
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        
        let yearPred = NSPredicate(format: "year == %i", year)
        let monthPred = NSPredicate(format: "month == %i", month)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPred, monthPred])
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        
        monthYearLabel.text = formatter.string(from: date)
        
        if let amt = expenseResultController.fetchedObjects?.map({ $0.amount }).reduce(0, +), amt > 0 {
            expenseAmountLabel.text = "\(amt)"
        } else {
            expenseAmountLabel.text = "000"
        }
        
        do {
            try categoryResultController.performFetch()
            tableView.reloadData()
        } catch let error as NSError {
            print(error)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as? CategoryTableViewCell else {
            fatalError("Invalid cell")
        }
        
        let category = categoryResultController.object(at: indexPath)
        cell.bind(category: category)

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
