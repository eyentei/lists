//
//  WelcomeViewController.swift
//  lists
//
//  Created by Мария Коровина on 23.02.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    func check() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if (email.isEmpty || password.isEmpty) {
            
        } else {
            //UserDefaults.standard.set(true, forKey: "hasLoggedInOrSkipped")
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        check()
    }
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        check()
    }
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        
        UserDefaults.standard.set(true, forKey: "hasLoggedInOrSkipped")
        self.performSegue(withIdentifier: "segueToMain", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
