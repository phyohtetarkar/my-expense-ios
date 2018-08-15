//
//  ExpensesViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/14/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {
    
    private var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private lazy var fetchedResultController: NSFetchedResultsController<Expense> = {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
