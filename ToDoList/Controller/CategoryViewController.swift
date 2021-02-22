//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Khaled Mohab on 2/16/21.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipableClass {
    var items : Results<Category>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
    }

    //MARK: - TableView DataSource Methods
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return items.count
     }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        cell.backgroundColor = UIColor(hexString: items[indexPath.row].color)
        return cell
     }
     //MARK: - TableView Delegate Methods
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = self.items[indexPath.row]
        }
    }
    
    
     //MARK: - Add new Items
     
    @IBAction func AddBtnPressed(_ sender: UIBarButtonItem) {
            var textField = UITextField()
                     let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
                     let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                         if let safetext = textField.text{
                             if safetext != "" {
                                 let tempItem = Category()
                                 tempItem.name = safetext
                                self.saveItems(category: tempItem)
                             }
                         }
            
                     }
                     alert.addTextField { (alertTextField) in
                         alertTextField.placeholder = "Create new item "
                         textField = alertTextField
                     }
                     alert.addAction(action)
                     present(alert, animated: true, completion: nil)
        }

     
    func saveItems(category:Category){
         do {
            try realm.write({
                realm.add(category)
            })
         } catch {
             print("Error encoding item array \(error)")
         }
         
         loadItems()
//         self.tableView.reloadData()

     }
     func loadItems() {
        items = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
        self.tableView.reloadData()
     }
    
    override func updateModel(at indexPath: IndexPath) {
        if let result = self.items?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(result)
                }
            } catch {
                print("Error in saving\(error)")
            }
           
            
        }
    }
    
}

//extension CategoryViewController: SwipeTableViewCellDelegate{
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            let result = self.items[indexPath.row]
//            try! self.realm.write {
//                self.realm.delete(result)
//            }
//        }
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//}
