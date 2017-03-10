//
//  ListTableViewController.swift
//  lists
//
//  Created by Мария Коровина on 09.03.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    var listTitle = "Title"
    var listItems: [Item] = []
    var list: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count + 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextTableViewCell
            cell.textField.text = listTitle
            cell.textField.textAlignment = .center
            cell.backgroundColor = UIColor.gray
            cell.textField.addTarget(self, action: #selector(self.handleTextFieldEditing(_:)), for: .editingDidEnd)
            cell.textField.tag = indexPath.row

            return cell
        case listItems.count + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlusCell", for: indexPath)
            cell.textLabel?.text = "+"
            cell.textLabel?.textAlignment = .center
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextTableViewCell
            cell.textField.addTarget(self, action: #selector(self.handleTextFieldEditing(_:)), for: .editingDidEnd)
            cell.textField.text = listItems[indexPath.row - 1].text
            cell.textField.tag = indexPath.row
            return cell

        }
       
    }
    
    func handleTextFieldEditing(_ sender: UITextField) {
        if (sender.tag == 0) {
            listTitle = sender.text!
        } else {
            listItems[sender.tag - 1].text = sender.text!
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == listItems.count + 1) {
            var itemTextField: UITextField?
            let alert = UIAlertController(title: "", message: "Add a new task", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField!) -> Void in
                itemTextField = textField
            }
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                self.listItems.append(Item(text: (itemTextField?.text)!))
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0 && indexPath.row != listItems.count + 1)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
            if (editingStyle == .delete) {
                listItems.remove(at: indexPath.row - 1)
                tableView.reloadData()
            }
        
    }
    
    
    /*func fetchAllInListItem() -> List {
        var listItems = [Item]()
        item.app..
        let titleString = self.tableView.cellForRow(at:IndexPath(row: 0, section:0)) as!
        let list = List(title: titleString, listItems: listItems)
    }*/
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
       // var list = List(title: self.index, listItems: listItems)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
