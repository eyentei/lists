//
//  List.swift
//  lists
//
//  Created by Мария Коровина on 09.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

class List: NSObject {
    var title: String!
    var items: [Item]!
    var screenshot: URL!
    
    init(title:String, items:[Item], screenshot:URL) {
        self.title = title
        self.items = items
        self.screenshot = screenshot
    }
    
}
