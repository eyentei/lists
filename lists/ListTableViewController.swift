//
//  ListTableViewController.swift
//  lists
//
//  Created by Мария Коровина on 09.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableViewController: UITableViewController {
    
    var isEdited = false
    var toDoList: ToDoList = ToDoList()
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!isEdited) {
            try! realm.write {
                realm.add(toDoList)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            toDoList.screenshot = takeScreenshot()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.entriesArray.count + 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextTableViewCell
            cell.textField.text = toDoList.title
            cell.textField.textAlignment = .center
            cell.backgroundColor = UIColor.gray
            cell.textField.addTarget(self, action: #selector(self.handleTextFieldEditing(_:)), for: .editingDidEnd)
            cell.textField.tag = indexPath.row
            return cell
        case toDoList.entriesArray.count + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlusCell", for: indexPath)
            cell.textLabel?.text = "+"
            cell.textLabel?.textAlignment = .center
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextTableViewCell
            cell.textField.text = toDoList.entriesArray[indexPath.row - 1].text
            cell.textField.addTarget(self, action: #selector(self.handleTextFieldEditing(_:)), for: .editingDidEnd)
            cell.textField.tag = indexPath.row
            return cell
        }
    }
    
    func handleTextFieldEditing(_ sender: UITextField) {
        if (sender.tag == 0) {
            try! realm.write {
                toDoList.title = sender.text!
            }
        } else {
            try! realm.write {
                toDoList.entriesArray[sender.tag - 1].text = sender.text!
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == toDoList.entriesArray.count + 1) {
            var itemTextField: UITextField?
            let alert = UIAlertController(title: "", message: "Add a new task", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField!) -> Void in
                itemTextField = textField
            }
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                try! self.realm.write {
                    self.toDoList.entriesArray.append(Entry(value: ["text": itemTextField?.text]))
                }
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0 && indexPath.row != toDoList.entriesArray.count + 1)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
            if (editingStyle == .delete) {
                try! realm.write {
                    toDoList.entriesArray.remove(at: indexPath.row - 1)
                }
                tableView.reloadData()
            }
    }
   
    
}

