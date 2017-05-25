//
//  SettingsViewController.swift
//  lists
//
//  Created by Мария Коровина on 24.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    // Everything here is similar to the welcome view controller (keyboard hiding methods, checking inputs, 
    // establishing connections, showing errors, etc.
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLabel.text = ""
        textField.backgroundColor = UIColor.clear
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            errorLabel.text = "Please fill in both fields"
            textField.backgroundColor = UIColor(hue: 0, saturation: 0.25, brightness: 1, alpha: 1.0)
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return !(string == " ")
    }
    
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        user = nil
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        guard let oldPassword = oldPasswordTextField.text, let newPassword = newPasswordTextField.text,
            !oldPassword.isEmpty, !newPassword.isEmpty else {
                errorLabel.text = "Please fill in both fields"
                return
        }
        
        guard user!.password == oldPasswordTextField.text else {
            errorLabel.text = "Wrong password"
            return
        }
        
        realm = try! Realm(configuration: config)
        try! realm.write {
            user!.password = newPassword
        }
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
