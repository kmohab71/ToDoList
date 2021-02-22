//
//  ViewController.swift
//  ToDoList
//
//  Created by Khaled Mohab on 1/21/21.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoViewController: SwipableClass {
    
    var items : Results<Item>!
    let realm = try! Realm()

    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("navbar is nill")
        }
        if let backgroundColor = selectedCategory?.color{
            navBar.barTintColor = UIColor(hexString: backgroundColor)
            navBar.tintColor = ContrastColorOf(UIColor(hexString: backgroundColor)!, returnFlat: true)
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: backgroundColor)!, returnFlat: true)]
            searchBar.barTintColor = UIColor(hexString: backgroundColor)
            searchBar.tintColor = ContrastColorOf(UIColor(hexString: backgroundColor)!, returnFlat: true)
            
        }

    }
    
   //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Ask for a cell of the appropriate type.
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        let perc = CGFloat(indexPath.row)/CGFloat(items.count)
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: perc){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
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
    func loadItems(with keyword:String? = nil) {
        if let word = keyword{
            items = realm.objects(Item.self).filter("%@ IN category", selectedCategory!).filter("title CONTAINS [cd] %@", word).sorted(byKeyPath: "dateCreated", ascending: true)
        }else{
            items = realm.objects(Item.self).filter("%@ IN category", selectedCategory!).sorted(byKeyPath: "dateCreated", ascending: false)
        }
        
        
        self.tableView.reloadData()
    }

    @IBAction func DoneBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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

//MARK: - Search bar methods
extension ToDoViewController: UISearchBarDelegate{
    func search(text:String){
        loadItems(with: text)
        
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
