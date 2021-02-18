//
//  Item.swift
//  ToDoList
//
//  Created by Khaled Mohab on 2/18/21.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var category = LinkingObjects(fromType:Category.self,property:"items")
}
