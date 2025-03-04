//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Khaled Mohab on 2/16/21.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var items = [Category]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
                                 let tempItem = Category(context: self.contex)
                                 tempItem.name = safetext
                                 self.items.append(tempItem)
                                 self.saveItems()
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

     
     func saveItems(){
         do {
             try contex.save()
         } catch {
             print("Error encoding item array \(error)")
         }
         
         loadItems()
     }
     func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
             do {
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))]
                items = try contex.fetch(request)
             } catch {
                 print("Error decoding item array \(error)")
             }
             self.tableView.reloadData()
     }

    
}
