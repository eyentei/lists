//
//  ListInitViewController.swift
//  lists
//
//  Created by Мария Коровина on 20.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

class ListInitViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegate, UITextFieldDelegate {

    // Icon names array, without extensions
    var iconsData = ["list", "shoppingcart", "suitcase", "giftbox", "point", "book", "heart", "star"]
    var counter: Int = 0 // Counter for populating collection view
    var selectedIcon: String! // Name of selected icon
    @IBOutlet weak var listTitle: UITextField!
    @IBOutlet weak var iconsCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        listTitle.delegate = self
        iconsCollection.delegate = self
        iconsCollection.dataSource = self
        iconsCollection.allowsMultipleSelection = false
        
        // Default selected cell is the first one
        selectedIcon = iconsData[0]
            }
    override func viewDidAppear(_ animated: Bool) {
        
        // Selecting the first cell and giving it a blue border
        let cell = iconsCollection.cellForItem(at: IndexPath(item: 0, section: 0)) as! ListIconCollectionViewCell
        cell.isSelected = true
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.blue.cgColor
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon",
                                                      for: indexPath) as! ListIconCollectionViewCell
        // Iterating through icons
        let currentIcon = iconsData[counter]
        counter += 1
        cell.listIcon.image = UIImage(named: currentIcon)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of collection view cells is equal to number of icons
        return iconsData.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListIconCollectionViewCell
        let defaultCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! ListIconCollectionViewCell
        
        // Manually deselecting default (first) cell
        defaultCell.isSelected = false
        defaultCell.layer.borderWidth = 0
        
        // Selecting a new cell
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.blue.cgColor
        selectedIcon = iconsData[indexPath.item]
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListIconCollectionViewCell
        
        // Deselecting
        cell.layer.borderWidth = 0
    }

    @IBAction func nextButtonClicked(_ sender: UIBarButtonItem) {
        
        // Going to the next view to populate our newly created list
        performSegue(withIdentifier: "segueToListPopulation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let LTVC = segue.destination as? ListTableViewController {
            
            // Passing selected icon name and list title to the next view
            LTVC.icon = selectedIcon
            LTVC.listTitle.text = listTitle.text!
        }
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
