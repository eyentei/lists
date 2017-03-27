//
//  ToDoList.swift
//  lists
//
//  Created by Мария Коровина on 09.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoList: Object {
    
    dynamic var title = "Title"
    dynamic var screenshot = ""
    var entriesArray: List<Entry> = List<Entry>()
    
}
