//
//  Category.swift
//  ToDoList
//
//  Created by Khaled Mohab on 2/18/21.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = UIColor.randomFlat().hexValue()

    
    var items = List<Item>()
}
