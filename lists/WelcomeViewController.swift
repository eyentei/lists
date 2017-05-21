//
//  WelcomeViewController.swift
//  lists
//
//  Created by Мария Коровина on 23.02.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
        print(Realm.Configuration.defaultConfiguration.fileURL)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !(string == " ")
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        setupRealm()
        realm = try! Realm()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else
        {
            errorLabel.text = "Please fill in both fields"
            return
        }
            
        guard let currentUser = realm.object(ofType: User.self, forPrimaryKey: email), currentUser.password == password else
        {
            errorLabel.text = "Wrong login or password"
            return
        }
        user = currentUser
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        performSegue(withIdentifier: "segueToMain", sender: nil)
        
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        
        setupRealm()
        realm = try! Realm()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            errorLabel.text = "Please fill in both fields"
            return
        }
            
        try! realm.write {
            guard (realm.object(ofType: User.self, forPrimaryKey: email) == nil) else
            {
                errorLabel.text = "This email is already in use"
                return
            }
            let newUser = User()
            newUser.email = email
            newUser.password = password
            realm.add(newUser)
            user = newUser
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            self.performSegue(withIdentifier: "segueToMain", sender: nil)
            
        }
    }
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToMain", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
