//
//  EditCategoryViewController.swift
//  MyExpense
//
//  Created by Phyo Htet Arkar on 8/10/18.
//  Copyright © 2018 Phyo Htet Arkar. All rights reserved.
//

import UIKit
import CoreData

let CATEGORYCOLORS: [Int: UIColor] = [
    0: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), 1: #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1), 2: #colorLiteral(red: 1, green: 0.4863265157, blue: 0, alpha: 1), 3: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), 4: #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1),
    5: #colorLiteral(red: 0.8466523886, green: 0.3456366658, blue: 1, alpha: 1), 6: #colorLiteral(red: 0.6638882756, green: 0.6557548046, blue: 0.2578871548, alpha: 1), 7: #colorLiteral(red: 0.2199882269, green: 0.8307816982, blue: 0.8380283117, alpha: 1), 8: #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1), 9: #colorLiteral(red: 0.8439414501, green: 0.4790760279, blue: 0, alpha: 1)
]

class EditCategoryViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var sectionCount = 3
    
    private var selectedColorIndexPath: IndexPath? = nil

    @IBOutlet weak var nameTextField: UITextField!
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
        
        nameTextField.text = category?.name
        
        colorsView.dataSource = self
        colorsView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionCount
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
    
    // MARK: - Colors view datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CATEGORYCOLORS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorsView.dequeueReusableCell(withReuseIdentifier: "cellColor", for: indexPath)
        
        cell.backgroundColor = CATEGORYCOLORS[Int(indexPath.row)]
        cell.layer.cornerRadius = 2.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    // MARK: - Colors view action
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectColor(indexPath: indexPath)
    }
    
    // MARK: - Navigation Button action
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if category == nil {
            category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category
        }
        
        category?.name = nameTextField.text
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
    
    // MARK: - Private methods
    
    private func selectColor(indexPath: IndexPath) {
        if let selectedIndex = selectedColorIndexPath {
            let cell = colorsView.cellForItem(at: selectedIndex)
            cell?.layer.borderWidth = 0.0
        }
        
        let cell = colorsView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
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
