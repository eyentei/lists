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
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    var realm: Realm! // Database connection instance
    var localLists: Results<ToDoList>? // Locally saved tasks

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = "" // Hiding error label
        loadIndicator.isHidden = true // Hiding load indicator
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Hiding error text and red color when tapping on a text field
        errorLabel.text = ""
        textField.backgroundColor = UIColor.clear
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // If text field is empty, painting it red and showing an error
        guard let text = textField.text, !text.isEmpty else {
            errorLabel.text = "Please fill in both fields"
            textField.backgroundColor = UIColor(hue: 0, saturation: 0.25, brightness: 1, alpha: 1.0)
            return
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // Deleting whitespaces from string
        return !(string == " ")
    }

    @IBAction func loginButtonClicked(_ sender: UIButton) {
        // Hiding error message, if present
        errorLabel.text = ""
        
        // If email and/or password fields are empty, showing an error
        guard let email = emailTextField.text, let password = passwordTextField.text,
            !email.isEmpty, !password.isEmpty else {
            errorLabel.text = "Please fill in both fields"
            return
        }
        
        // Setting up connection to the server database
        setupRealm(completed: { () -> Void in
            DispatchQueue.main.async {
                // If password is wrong, showing an error, else getting current user
                guard let currentUser = self.realm.object(ofType: User.self, forPrimaryKey: email),
                                                          currentUser.password == password else {
                    // Showing load indicator while function executes (while fetching data from server)
                    self.loadIndicator.isHidden = true
                    self.errorLabel.text = "Wrong login or password"
                    return
                }

                user = currentUser
                // Everything is ok, hiding load indicator
                self.loadIndicator.isHidden = true
                // Going to the lists screen
                self.performSegue(withIdentifier: "segueToListsTable", sender: nil)
            }
        })
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        
        errorLabel.text = ""
        
        guard let email = emailTextField.text, let password = passwordTextField.text,
            !email.isEmpty, !password.isEmpty else {
            errorLabel.text = "Please fill in both fields"
            return
        }

        // Checking if the string is in the email format
        guard isEmail() else {
            errorLabel.text = "Invalid email format"
            return
        }
        
        realm = try! Realm()
        // Fetching previously created local lists to add them to the newly created account
        localLists = realm.objects(ToDoList.self)
        
        setupRealm(completed: { () -> Void in
            DispatchQueue.main.async {
                
                try! self.realm.write {
                    // Checking if the email is in use
                    guard self.realm.object(ofType: User.self, forPrimaryKey: email) == nil else {
                        // Showing load indicator while function executes (while fetching data from server)
                        self.loadIndicator.isHidden = true
                        self.errorLabel.text = "This email is already in use"
                        return
                    }
                    
                    // Creating new user and writing its data to the db
                    let newUser = User()
                    newUser.email = email
                    newUser.password = password
                    self.realm.add(newUser)
                    user = newUser
                    // If user has created any lists before, they will be added to their account
                    for list in self.localLists! {
                        user?.lists.append(self.realm.create(ToDoList.self, value: list, update: false))
                    }
                    
                    self.loadIndicator.isHidden = true
                    
                    self.performSegue(withIdentifier: "segueToListsTable", sender: nil)
                }
            }
        })
    }

    @IBAction func skipButtonClicked(_ sender: UIButton) {
        // Proceeding without registration or logging in
        performSegue(withIdentifier: "segueToListsTable", sender: nil)
    }

    func setupRealm(completed: @escaping () -> Void) {
        // Showing load indicator while function executes (while fetching data from server)
        loadIndicator.startAnimating()
        loadIndicator.isHidden = false

        // Connection to the server database with credentials held in LoginData.swift
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false),
                       server: authServerURL) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
                config = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: realmURL), schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in })
            
            DispatchQueue.main.async {
                self.realm = try! Realm(configuration: config!)
            }
            completed()
        }
    }

    func isEmail() -> Bool {
        // Checking if string is in the email format (looking for @ and . and some symbols in between)
        let regex = ".+@.+\\..+"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: emailTextField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hiding keyboard on return button tap
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hiding keyboard by tapping anywhere in the view
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
