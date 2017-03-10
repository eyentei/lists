//
//  List.swift
//  lists
//
//  Created by Мария Коровина on 09.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import Foundation

class List {
    var title: String?
    var items: [Item]
    
    init(title:String, items:[Item]) {
        self.title = title
        self.items = items
    }
    
}
