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

    var toDoList: ToDoList = ToDoList()
    var realm: Realm!
    var icon: String?
    @IBOutlet weak var listTitle: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        initialize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listTitle.delegate = self
        listTitle.tag = 0
        listTitle.addTarget(self, action: #selector(self.handleTextFieldEditing(_:)), for: .editingDidEnd)
    }

    func initialize() {
        realm = try! Realm()
        try! realm.write {
            if user != nil {
                if toDoList.picture == "" {
                    toDoList.title = listTitle.text! == "" ? "Untitled" : listTitle.text!
                    user!.lists.append(toDoList)
                } else {
                    listTitle.text = self.toDoList.title
                }
            } else {
                if toDoList.picture == "" {
                    toDoList.title = listTitle.text! == "" ? "Untitled" : listTitle.text!
                }
                realm.add(toDoList)
            }

            if icon != nil {
                toDoList.picture = self.icon!
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if !(navigationController?.viewControllers)!.contains(self) {
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
        super.viewWillDisappear(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.entries.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case toDoList.entries.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "plusCell", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextTableViewCell
            cell.textField.text = toDoList.entries[indexPath.row].text
            cell.textField.addTarget(self, action: #selector(self.handleTextFieldEditing(_:)), for: .editingDidEnd)
            cell.textField.tag = indexPath.row + 1
            return cell
        }
    }

    func handleTextFieldEditing(_ sender: UITextField) {
        try! realm.write {
            if sender.tag == 0 {
                toDoList.title = sender.text!
            } else {
                toDoList.entries[sender.tag - 1].text = sender.text!
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == toDoList.entries.count {

            var itemTextField: UITextField?
            let alert = UIAlertController(title: "", message: "Add a new task", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField!) -> Void in
                itemTextField = textField
                itemTextField?.delegate = self
            }
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                try! self.realm.write {
                    self.toDoList.entries.append(Entry(value: ["text": itemTextField?.text]))
                }
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != toDoList.entries.count)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realm = try! Realm()
            try! realm.write {
                toDoList.entries.remove(at: indexPath.row)
            }
            tableView.reloadData()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}