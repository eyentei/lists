//
//  UIViewController+DocumentDirectory.swift
//  lists
//
//  Created by Мария Коровина on 27.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

extension UIViewController {
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
