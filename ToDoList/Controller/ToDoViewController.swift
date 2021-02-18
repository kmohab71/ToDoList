//
//  ViewController.swift
//  ToDoList
//
//  Created by Khaled Mohab on 1/21/21.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    var items : Results<Item>!
    let realm = try! Realm()

    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      
    }
    
   //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Ask for a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
            
       // Configure the cell’s contents with the row and section number.
       // The Basic cell style guarantees a label view is present in textLabel.
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        
       return cell
    }
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        try! realm.write {
                items[indexPath.row].done = !items[indexPath.row].done
            }
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
    //MARK: - Add new Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new to doey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safetext = textField.text{
                if safetext != "" {
                    let tempItem = Item()
                    tempItem.title = safetext
                    tempItem.done = false
                    self.saveItems(item: tempItem)
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
    
    func saveItems(item:Item){
         do {
            try realm.write({
                realm.add(item)
                self.selectedCategory?.items.append(item)
            })
         } catch {
             print("Error encoding item array \(error)")
         }
         
//         loadItems()
        self.tableView.reloadData()

     }
    func loadItems() {
        items = realm.objects(Item.self).filter("%@ IN category", selectedCategory!).sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }

    @IBAction func DoneBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Search bar methods
//extension ToDoViewController: UISearchBarDelegate{
//    func search(text:String){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS [cd] %@", text)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request)
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if let safetext = searchBar.text{
//            if safetext != "" {
//                search(text: safetext)
//            }
//        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }else{
//            if let safetext = searchBar.text{
//                if safetext != "" {
//                    search(text: safetext)
//                }
//            }
//        }
//    }
//}
