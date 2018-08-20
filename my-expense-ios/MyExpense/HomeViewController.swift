//
//  HomeViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/16/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import Charts
import CoreData

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    private lazy var expenseResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        let comp = Date().toComponent()
        
        let yearPred = NSPredicate(format: "year == %i", comp.0)
        let monthPred = NSPredicate(format: "month == %i", comp.1)
        let dayPred = NSPredicate(format: "day == %i", comp.2)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPred, monthPred, dayPred])
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.chartDescription = nil
        pieChartView.drawEntryLabelsEnabled = false
        
        barChartView.chartDescription = nil
        barChartView.xAxis.drawLabelsEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false

        do {
            try expenseResultController.performFetch()
            
            pieChartView.data = ExpenseDataManager.pieChartDataByCategory(expenses: expenseResultController.fetchedObjects)
            barChartView.data = ExpenseDataManager.barChartDataByCategory(expenses: expenseResultController.fetchedObjects)
        } catch let error as NSError {
            fatalError(error.description)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pieChartView.data = ExpenseDataManager.pieChartDataByCategory(expenses: controller.fetchedObjects as? [Expense])
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
