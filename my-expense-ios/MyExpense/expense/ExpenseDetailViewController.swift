//
//  ExpenseDetailViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/15/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData
import Charts

fileprivate let expenseReuseIdentifier = "cellExpenseDetail"

class ExpenseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var pieChartView: PieChartView!    
    @IBOutlet weak var tableView: UITableView!
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    private lazy var fetchedResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        let comp = detail!.date.toComponent()
        
        let yearPred = NSPredicate(format: "year = %i", comp.0)
        let monthPred = NSPredicate(format: "month = %i", comp.1)
        let dayPred = NSPredicate(format: "day = %i", comp.2)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPred, monthPred, dayPred])
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()
    
    var detail: ExpenseDetail? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = detail else {
            fatalError("null detail.")
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        pieChartView.chartDescription?.font = UIFont.systemFont(ofSize: 16)
        pieChartView.chartDescription?.text = detail!.date.appDefaultFormat()
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.usePercentValuesEnabled = true
        pieChartView.holeColor = UIColor.clear
        
        
        do {
            try fetchedResultController.performFetch()
            
            pieChartView.data = ExpenseDataManager.pieChartDataByCategory(expenses: fetchedResultController.fetchedObjects)
            
            calculateTotal()
            
            pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
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

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.fetchedObjects?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expenseReuseIdentifier, for: indexPath)
            
        let exp = fetchedResultController.object(at: indexPath)
            
        cell.textLabel?.text = exp.title
        cell.detailTextLabel?.text = exp.amount.asString()
            
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let dest = segue.destination as? EditExpenseViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let cell = sender as? UITableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        dest.expense = fetchedResultController.object(at: indexPath)
        dest.title = "Edit Expense"
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pieChartView.data = ExpenseDataManager.pieChartDataByCategory(expenses: controller.fetchedObjects as? [Expense])
        tableView.reloadData()
        calculateTotal()
    }
    
    private func calculateTotal() {
        let total = fetchedResultController.fetchedObjects?.map({ $0.amount }).reduce(0, +) ?? 0
        pieChartView.centerText = "Total\n\(total.asString())"
    }

}
