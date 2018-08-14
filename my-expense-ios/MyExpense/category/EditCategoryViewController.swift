//
//  EditCategoryViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

class EditCategoryViewController: UITableViewController {
    
    private var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var sectionCount = 3

    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var colorsView: UICollectionView!
    
    var category: Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if category == nil {
            sectionCount = 2
        }
        
        categoryNameTextField.text = category?.name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view action
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure to delete category?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [unowned self] action in
                self.context.delete(self.category!)
                do {
                    try self.context.save()
                } catch let error as NSError {
                    print(error)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation Button action
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if category == nil {
            category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context)
        }
        
        category?.name = categoryNameTextField.text
        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionCount
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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

}
