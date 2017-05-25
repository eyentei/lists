//
//  User.swift
//  lists
//
//  Created by Мария Коровина on 30.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

// User model

class User: Object {

    dynamic var email = ""
    dynamic var password = ""
    var lists: List<ToDoList> = List<ToDoList>()
    override class func primaryKey() -> String? {
        return "email"
    }
}
