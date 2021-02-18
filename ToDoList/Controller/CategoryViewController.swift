//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Khaled Mohab on 2/16/21.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as UITableViewCell
             
        // Configure the cell’s contents with the row and section number.
        // The Basic cell style guarantees a label view is present in textLabel.
        cell.textLabel?.text = items[indexPath.row].name
         
        return cell
     }
     //MARK: - TableView Delegate Methods
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         saveItems()
//         tableView.deselectRow(at: indexPath, animated: true)
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

    
}
