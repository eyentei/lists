//
//  ListTableViewController.swift
//  lists
//
//  Created by Мария Коровина on 09.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController, UITextFieldDelegate {

    
    var toDoList: ToDoList? // Current list
    var realm: Realm! // Database connection instance
    var icon: String? // Selected icon
    var transparentButton: UIButton? // Helper button
    @IBOutlet weak var listTitle: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        
        // Getting initial data from db, and/or updating it
        initialize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listTitle.delegate = self
        
        // Setting tag to identify needed row
        listTitle.tag = 0
        
        // Handler for what happens on end of text field editing
        listTitle.addTarget(self, action: #selector(handleTextFieldEditing(_:)), for: .editingDidEnd)

        
        // Workaround to change back button behavior
        transparentButton = UIButton()
        transparentButton!.frame =  CGRect(x: 0, y: 0, width: 80, height: 45)
        transparentButton!.addTarget(self, action: #selector(backButtonClick(_:)), for:.touchUpInside)
        self.navigationController?.navigationBar.addSubview(transparentButton!)
    }

    func backButtonClick(_ sender: UIButton) {
        
        // Changing back button behavior to always get to ListsTableViewController (screen with lists)
        if let vcStack = self.navigationController?.viewControllers {
            // Searching for the needed view controller
            for vc in vcStack {
                if vc.isKind(of: ListsTableViewController.self) {
                    self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
        // Hiding helper button, because we don't need it anywhere else
        transparentButton?.isHidden = true
    }

    func initialize() {
        
        // If user is logged in
        if let user = user {
            // Connecting to server (config is global, it is set in LoginData.swift file)
            realm = try! Realm(configuration: config!)
            try! realm.write {
                if let toDoList = toDoList {
                    // If toDoList already exists, it means we're editing our list, not creating it
                    // Getting title from the db and setting it in view
                    listTitle.text = toDoList.title
                } else {
                    // If it doesn't exist, we're creating it
                    toDoList = ToDoList()
                    // and setting its properties
                    toDoList!.title = listTitle.text! == "" ? "Untitled" : listTitle.text!
                    toDoList!.picture = icon!
                    toDoList!.owner = user
                    // And writing it to the database
                    user.lists.append(toDoList!)
                }
            }
        } else { // If user is not logged in
            
            // Connecting to local db
            realm = try! Realm()
            try! realm.write {
                if let toDoList = toDoList {
                    // Editing, getting title from the db and setting it in view
                    listTitle.text = toDoList.title
                } else {
                    // Creating object and writing it to the database
                    toDoList = ToDoList()
                    toDoList!.title = listTitle.text! == "" ? "Untitled" : listTitle.text!
                    toDoList!.picture = self.icon!
                    realm.add(toDoList!)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Number of cells is equal to number of entries plus one (the "+")
        return toDoList!.entries.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
            // The last cell is the "+"
        case toDoList!.entries.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
            return cell
        default:
            // All other are the entries (tasks)
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextTableViewCell
            
            // Changing cell text
            cell.textField.text = toDoList!.entries[indexPath.row].text
            
            // Setting handler for end of text field editing
            cell.textField.addTarget(self, action: #selector(self.handleTextFieldEditing(_:)), for: .editingDidEnd)
            
            // Setting tags to identify our cell later
            cell.textField.tag = indexPath.row + 1
            return cell
        }
    }

    func handleTextFieldEditing(_ sender: UITextField) {

        // Choosing type of connection (online/offline)
        if user != nil {
            // If user is logged in, using online connection
            realm = try! Realm(configuration: config)
        } else {
            // If not, using local realm
            realm = try! Realm()
        }

        try! realm.write {
            
            // Checking tags of our text fields to know what we've just edited
            if sender.tag == 0 {
                // 0 is the title textfield
                toDoList!.title = sender.text!
            } else {
                // Any other number means it's a task
                toDoList!.entries[sender.tag - 1].text = sender.text!
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Choosing type of connection (online/offline)
        if user != nil {
            realm = try! Realm(configuration: config)
        } else {
            realm = try! Realm()
        }

        // Cell tap handling
        // If the "+" cell is tapped, we're creating an alert to input our task
        if indexPath.row == toDoList?.entries.count {
            // Creating a text field and an alert
            var itemTextField: UITextField?
            let alert = UIAlertController(title: "", message: "Add a new task", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField!) -> Void in
                itemTextField = textField
                itemTextField?.delegate = self
            }
            
            // When "Ok" is tapped, the entry is saved to the database
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                try! self.realm.write {
                    self.toDoList!.entries.append(Entry(value: ["text": itemTextField?.text]))
                }
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Specifying editable cells (all except for "+")
        return (indexPath.row != toDoList?.entries.count)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Deletion handler
            
            if user != nil {
                realm = try! Realm(configuration: config)
            } else {
                realm = try! Realm()
            }
            
            // Deleting entry from the list and the database
            try! realm.write {
                toDoList!.entries.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hiding keyboard on return button tap
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
