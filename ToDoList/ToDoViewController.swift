//
//  ViewController.swift
//  ToDoList
//
//  Created by Khaled Mohab on 1/21/21.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var items = ["Read papers for GP", "Study hierographics", "Take IOS development course"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Ask for a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
            
       // Configure the cell’s contents with the row and section number.
       // The Basic cell style guarantees a label view is present in textLabel.
        cell.textLabel?.text = items[indexPath.row]
       return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new to doey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let safetext = textField.text{
                if safetext != "" {
                    self.items.append(safetext)
                    self.tableView.reloadData()
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
}

