//
//  UIViewController+hideKeyboardOnTap.swift
//  lists
//
//  Created by Мария Коровина on 20.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
