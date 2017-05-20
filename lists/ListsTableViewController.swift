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
    var results: Results<ToDoList>?
    
    override func viewDidAppear(_ animated: Bool) {
        setupRealm()
    }

    func setupRealm() {
        self.realm = try! Realm()
        self.results = self.realm.objects(ToDoList.self)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results != nil ? results!.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listInfoCell", for: indexPath) as! ListInfoTableViewCell
        guard let results = results else
        {
            return cell
        }
        cell.listName.text = results[indexPath.row].title
        let num = results[indexPath.row].entries.count
        cell.tasksNumber.text = num == 1 ? "\(num) task in list" : "\(num) tasks in list"
        cell.listIcon.image = UIImage(named: results[indexPath.row].picture + ".png")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            try! realm.write {
                realm.delete(results![indexPath.row].entries)
                realm.delete(results![indexPath.row])
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToList", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueToList") {
            if let LTVC = segue.destination as? ListTableViewController {
                if (sender is Int) { LTVC.toDoList = results![sender as! Int] }
            }
        }
    }
}
