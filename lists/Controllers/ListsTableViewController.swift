//
//  ListsTableViewController.swift
//  lists
//
//  Created by Мария Коровина on 19.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

class ListsTableViewController: UITableViewController {

    var realm: Realm!
    var lists: List<ToDoList>?
    var results: Results<ToDoList>?
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        if user != nil {
            lists = user!.lists
            tableView.reloadData()
        } else {
            getData()
        }
    }

    func getData() {
        realm = try! Realm()
        results = realm.objects(ToDoList.self)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            leftBarButton.title = "Log In"
        } else {
            leftBarButton.title = "Settings"
        }
    }
    
    @IBAction func leftBarButtonClicked(_ sender: UIBarButtonItem) {
        if user == nil {
            navigationController?.popToRootViewController(animated: true)
        } else {
            performSegue(withIdentifier: "segueToSettings", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user != nil {
            return lists != nil ? lists!.count : 0
        } else {
            return results != nil ? results!.count : 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listInfoCell",
                                                 for: indexPath) as! ListInfoTableViewCell
        if user != nil {
            realm = try! Realm(configuration: config)
        } else {
            realm = try! Realm()
        }
        
        if user != nil {
            guard let lists = lists else {
                return cell
            }
            cell.listName.text = lists[indexPath.row].title
            let num = lists[indexPath.row].entries.count
            cell.tasksNumber.text = num == 1 ? "\(num) task in list" : "\(num) tasks in list"
            cell.listIcon.image = UIImage(named: lists[indexPath.row].picture + ".png")
            return cell
        } else {
            guard let results = results else {
                return cell
            }
            cell.listName.text = results[indexPath.row].title
            let num = results[indexPath.row].entries.count
            cell.tasksNumber.text = num == 1 ? "\(num) task in list" : "\(num) tasks in list"
            cell.listIcon.image = UIImage(named: results[indexPath.row].picture + ".png")
            return cell
        }

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if user != nil {
                realm = try! Realm(configuration: config)
            } else {
                realm = try! Realm()
            }
            
            try! realm.write {
                if user != nil {
                    realm.delete(lists![indexPath.row].entries)
                    realm.delete(lists![indexPath.row])
                } else {
                    realm.delete(results![indexPath.row].entries)
                    realm.delete(results![indexPath.row])
                }
            }
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToListEditing", sender: indexPath.row)
    }

    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueToListInit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToListEditing" {
            if let LTVC = segue.destination as? ListTableViewController {
                if sender is Int {
                    if user != nil {
                        LTVC.toDoList = lists![sender as! Int]
                    } else {
                        LTVC.toDoList = results![sender as! Int]
                    }
                }
            }
        }
    }
}
