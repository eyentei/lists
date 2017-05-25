//
//  ListsTableViewController.swift
//  lists
//
//  Created by Мария Коровина on 19.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class ListsTableViewController: UITableViewController, UISearchBarDelegate {

    var realm: Realm! // Database connection instance
    var lists: Results<ToDoList>? // Results of a get query to the db
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If user is logged in, showing Settings button
        if user != nil {
            leftBarButton.title = "Settings"
        } else {
        // Else showing Log In button
            leftBarButton.title = "Log In"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData() // Getting user's lists from the db
    }

    func getData() {
        
        // If logged in
        if user != nil {
            realm = try! Realm(configuration: config)
            // Getting lists by their owner (current user)
            lists = realm.objects(ToDoList.self).filter(NSPredicate(format: "owner == %@", user!))

        } else {
            // Getting locally saved lists, not linked to any account
            realm = try! Realm()
            lists = realm.objects(ToDoList.self)
        }
        tableView.reloadData()
    }
    
    @IBAction func leftBarButtonClicked(_ sender: UIBarButtonItem) {
        // Left button tap handler
        if user != nil {
            // If user is logged in, showing settings
            performSegue(withIdentifier: "segueToSettings", sender: nil)
        } else {
            // Going to auth screen
            navigationController?.popToRootViewController(animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Deciding how many cells we'll show; equals to number of lists
        return lists != nil ? lists!.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listInfoCell",
                                                 for: indexPath) as! ListInfoTableViewCell
        // If there's no lists, showing no cells
        guard let lists = lists else {
            return cell
        }
        
        // If user is logged in, connecting to server
        if user != nil {
            realm = try! Realm(configuration: config) // Config is set in the LoginData.swift file
        } else {
            // Else using local db
            realm = try! Realm()
        }
        // Setting list name in the cell (we read it from the db)
        cell.listName.text = lists[indexPath.row].title
        
        // Number of tasks in the list
        let num = lists[indexPath.row].entries.count
        cell.tasksNumber.text = num == 1 ? "\(num) task in list" : "\(num) tasks in list"
        
        // Chosen icon
        cell.listIcon.image = UIImage(named: lists[indexPath.row].picture + ".png")
        return cell
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
            
            try! realm.write {
                // Deleting entries (tasks) that belong to the list
                realm.delete(lists![indexPath.row].entries)
                // Deleting the list itself
                realm.delete(lists![indexPath.row])
            }
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Cell tap handler (going to list editing screen)
        performSegue(withIdentifier: "segueToListEditing", sender: indexPath.row)
    }

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        // Plus tap handler (going to list init screen)
        performSegue(withIdentifier: "segueToListInit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToListEditing" {
            if let LTVC = segue.destination as? ListTableViewController {
                if sender is Int {
                    // Passing the selected list to edit it in the next view
                    LTVC.toDoList = lists![sender as! Int]
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

