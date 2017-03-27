//
//  UIViewController+Screenshot.swift
//  lists
//
//  Created by Мария Коровина on 27.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

extension UIViewController {
    func takeScreenshot() -> String {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let imgName = "\(Date()).png"
        let data = UIImagePNGRepresentation(image)
        let absolutePath = getDocumentDirectory().appendingPathComponent(imgName)
        try? data?.write(to: absolutePath)
        return "/\(imgName)"
    }
}
