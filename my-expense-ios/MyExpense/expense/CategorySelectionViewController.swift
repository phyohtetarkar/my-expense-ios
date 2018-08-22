//
//  CategorySelectionViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/16/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

fileprivate let reuseIdentifier = "cellChooseCategory"

class CategorySelectionViewController: UITableViewController {
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext
    
    lazy var fetchedResultController: NSFetchedResultsController<Category> = {
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }()
    
    var selectedCategory: Category? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultController.performFetch()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let category = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = category.name

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
