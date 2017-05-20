//
//  ListInitViewController.swift
//  lists
//
//  Created by Мария Коровина on 20.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit

class ListInitViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var iconsData = ["list", "shoppingcart", "suitcase", "giftbox", "point", "book", "heart", "star"]
    var counter: Int = 0
    var selectedIcon: String!
    @IBOutlet weak var listTitle: UITextField!
    @IBOutlet weak var iconsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIcon = iconsData[0]
        iconsCollection.delegate = self
        iconsCollection.dataSource = self
        iconsCollection.allowsMultipleSelection = false
    }
    override func viewDidAppear(_ animated: Bool) {
        let cell = iconsCollection.cellForItem(at: IndexPath(item: 0, section: 0)) as! ListIconCollectionViewCell
        cell.isSelected = true
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.blue.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath) as! ListIconCollectionViewCell
        let currentIcon = iconsData[counter]
        counter += 1
        if counter >= iconsData.count {
            counter = 0
        }
        cell.listIcon.image = UIImage(named: currentIcon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsData.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListIconCollectionViewCell
        let cell0 = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! ListIconCollectionViewCell
        cell0.isSelected = false
        cell0.layer.borderWidth = 0
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.blue.cgColor
        selectedIcon = iconsData[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ListIconCollectionViewCell
        cell.layer.borderWidth = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let LTVC = segue.destination as? ListTableViewController {
            LTVC.icon = selectedIcon
            LTVC.listTitle.text = listTitle.text == "" ? "Untitled" : listTitle.text
        }
    }
}
