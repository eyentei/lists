//
//  ListInfoTableViewCell.swift
//  lists
//
//  Created by Мария Коровина on 19.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

class ListInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var tasksNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
