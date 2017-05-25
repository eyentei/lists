//
//  ToDoList.swift
//  lists
//
//  Created by Мария Коровина on 09.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

// List model

class ToDoList: Object {

    dynamic var title = "Untitled"
    dynamic var picture = ""
    dynamic var owner: User?
    var entries: List<Entry> = List<Entry>()
}
