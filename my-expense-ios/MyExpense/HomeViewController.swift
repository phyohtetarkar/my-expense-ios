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
    
    @IBOutlet weak var todayExpenseLabel: UILabel!
    @IBOutlet weak var thisMonthExpenseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    let comp = Date().toComponent()

    private var context: NSManagedObjectContext = AppDelegate.objectContext
    private lazy var todayResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        let yearPred = NSPredicate(format: "year == %i", comp.0)
        let monthPred = NSPredicate(format: "month == %i", comp.1)
        let dayPred = NSPredicate(format: "day == %i", comp.2)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPred, monthPred, dayPred])
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()
    
    private lazy var monthResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        let yearPred = NSPredicate(format: "year == %i", comp.0)
        let monthPred = NSPredicate(format: "month == %i", comp.1)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [yearPred, monthPred])
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.chartDescription = nil
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.horizontalAlignment = .right
        pieChartView.legend.verticalAlignment = .top
        pieChartView.usePercentValuesEnabled = true
        
        barChartView.chartDescription = nil
        barChartView.xAxis.drawLabelsEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
        
        do {
            try todayResultController.performFetch()
            try monthResultController.performFetch()
            
            pieChartView.data = ExpenseDataManager.pieChartDataByCategory(expenses: todayResultController.fetchedObjects)
            barChartView.data = ExpenseDataManager.barChartDataByCategory(expenses: monthResultController.fetchedObjects)
            
            reloadSummary()
        } catch let error as NSError {
            fatalError(error.description)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pieChartView.data = ExpenseDataManager.pieChartDataByCategory(expenses: todayResultController.fetchedObjects)
        barChartView.data = ExpenseDataManager.barChartDataByCategory(expenses: monthResultController.fetchedObjects)
        reloadSummary()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func reloadSummary() {
        todayExpenseLabel.text = todayResultController.fetchedObjects?.map({ $0.amount }).reduce(0, +).asString() ?? "000"
        thisMonthExpenseLabel.text = monthResultController.fetchedObjects?.map({ $0.amount }).reduce(0, +).asString() ?? "000"
    }

}
