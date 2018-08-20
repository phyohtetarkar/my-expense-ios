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

class EditCategoryViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext

    private var sectionCount = 3
    
    private var selectedColorIndexPath: IndexPath? = nil

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorsView: UICollectionView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var category: Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if category == nil {
            sectionCount = 2
            selectedColorIndexPath = IndexPath(item: 0, section: 0)
        }
        
        nameTextField.text = category?.name
        nameTextField.delegate = self
        
        colorsView.dataSource = self
        colorsView.delegate = self

        validate()
        
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
    
    // MARK: - TextField action
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
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
        
        if let index = selectedColorIndexPath, index == indexPath {
            cell.layer.borderWidth = 2.0
        }
        
        return cell
    }
    
    // MARK: - Colors view action
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectColor(indexPath: indexPath)
    }
    
    // MARK: - Navigation Button action
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if let oldCategory = category {
            oldCategory.name = nameTextField.text
            oldCategory.color = Int16(selectedColorIndexPath!.row)
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)!
            let newCategory = NSManagedObject(entity: entity, insertInto: context)
            
            newCategory.setValue(nameTextField.text, forKey: "name")
            newCategory.setValue(Int16(selectedColorIndexPath!.row), forKey: "color")
        }
        
        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Error saving category: \(error)")
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingModal = presentingViewController is UITabBarController
        
        if isPresentingModal {
            dismiss(animated: true, completion: nil)
        } else if let nav = navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    // MARK: - Private methods
    
    private func selectColor(indexPath: IndexPath) {
        
        if let selectedIndex = selectedColorIndexPath {
            let cell = colorsView.cellForItem(at: selectedIndex)
            cell?.layer.borderWidth = 0.0
        }
        
        let cell = colorsView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        
        selectedColorIndexPath = indexPath
    }
    
    private func validate() {
        guard let text = nameTextField.text, !text.isEmpty else {
            saveBarButton.isEnabled = false
            
            return
        }
        
        saveBarButton.isEnabled = true
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
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
