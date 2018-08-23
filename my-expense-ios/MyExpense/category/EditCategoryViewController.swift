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
    5: #colorLiteral(red: 0.8466523886, green: 0.3456366658, blue: 1, alpha: 1), 6: #colorLiteral(red: 0.6638882756, green: 0.6557548046, blue: 0.2578871548, alpha: 1), 7: #colorLiteral(red: 0.2199882269, green: 0.8307816982, blue: 0.8380283117, alpha: 1), 8: #colorLiteral(red: 0, green: 0.5008062124, blue: 1, alpha: 1), 9: #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
]

fileprivate let reuseIdentifier = "cellColor"

class EditCategoryViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    private var context: NSManagedObjectContext = AppDelegate.objectContext

    private var sectionCount = 3
    
    private var selectedColorIndexPath = IndexPath(item: 0, section: 0)

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorsView: UICollectionView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    var category: Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let c = category {
            nameTextField.text = c.name
            selectedColorIndexPath = IndexPath(item: c.color.toInt(), section: 0)
        } else {
            sectionCount = 2
            
        }
        
        nameTextField.delegate = self
        colorsView.dataSource = self
        colorsView.delegate = self

        validate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
        if indexPath.section == 2 {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let c = category, let exps = c.expenses, exps.count > 0 else {
                let alert = UIAlertController(title: "Are you sure to delete category \"\(category!.name!)\"?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self] action in
                    self.context.delete(self.category!)
                    do {
                        try self.context.save()
                        self.navigationController?.popViewController(animated: true)
                    } catch let error as NSError {
                        self.context.rollback()
                        print("Error deleting category: \(error)")
                    }
                }))
                
                present(alert, animated: true, completion: nil)
                return
            }
            
            let alert = AlertManager.info(title: "Cannot delete \"\(c.name!)\"", message: "Delete expenses of this category first.")
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Colors view datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CATEGORYCOLORS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorsView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = CATEGORYCOLORS[indexPath.row]
        cell.layer.cornerRadius = 2.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        if selectedColorIndexPath == indexPath {
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
        do {
            let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", nameTextField.text!)
            
            if let c = try context.fetch(fetchRequest).first, c.objectID != category?.objectID {
                let alert = AlertManager.info(title: "Warning", message: "Category with name \"\(nameTextField.text!)\" already exists.")
                present(alert, animated: true, completion: nil)
            } else {
                if category == nil {
                    category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category
                    category?.createdAt = Date()
                }
                
                category?.name = nameTextField.text
                category?.color = selectedColorIndexPath.row.toInt16()
                
                try context.save()
                cancel(sender)
            }
        } catch let error as NSError {
            context.rollback()
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
        
        let old = colorsView.cellForItem(at: selectedColorIndexPath)
        old?.layer.borderWidth = 0.0
        
        let new = colorsView.cellForItem(at: indexPath)
        new?.layer.borderWidth = 2.0
        
        selectedColorIndexPath = indexPath
    }
    
    private func validate() {
        if let text = nameTextField.text, !text.isEmpty {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }

}
