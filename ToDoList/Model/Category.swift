//
//  Category.swift
//  ToDoList
//
//  Created by Khaled Mohab on 2/18/21.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    
    var items = List<Item>()
}
