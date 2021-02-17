//
//  ViewController.swift
//  ToDoList
//
//  Created by Khaled Mohab on 1/21/21.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    var items = [Item]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add new Items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new to doey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safetext = textField.text{
                if safetext != "" {
                    let tempItem = Item(context: self.contex)
                    tempItem.title = safetext
                    tempItem.done = false
                    tempItem.category = self.selectedCategory
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
        
        self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
            do {
                if let pred = request.predicate{
                    let predicate1 = NSPredicate(format: "category.name MATCHES %@", self.selectedCategory!.name! as NSString)
                    let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [pred,predicate1])
                    request.predicate = predicateCompound
                }
                else{
                    request.predicate = NSPredicate(format: "category.name MATCHES %@", self.selectedCategory!.name! as NSString)
                }
                items = try contex.fetch(request)
            } catch {
                print("Error decoding item array \(error)")
            }
            self.tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension ToDoViewController: UISearchBarDelegate{
    func search(text:String){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS [cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let safetext = searchBar.text{
            if safetext != "" {
                search(text: safetext)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
            if let safetext = searchBar.text{
                if safetext != "" {
                    search(text: safetext)
                }
            }
        }
    }
}
