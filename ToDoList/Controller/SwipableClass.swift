//
//  SwipableClass.swift
//  ToDoList
//
//  Created by Khaled Mohab on 2/22/21.
//

import UIKit
import SwipeCellKit

class SwipableClass: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Ask for a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
       cell.delegate = self
       return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    func updateModel(at indexPath: IndexPath){
       
    }
}
