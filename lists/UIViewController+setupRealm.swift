//
//  UIViewController+setupRealm.swift
//  lists
//
//  Created by Мария Коровина on 21.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

extension UIViewController {
    
    func setupRealm() {
        
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: authServerURL) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            let configuration = Realm.Configuration(syncConfiguration: SyncConfiguration(user: user, realmURL: realmURL), schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in })
            
            Realm.Configuration.defaultConfiguration = configuration
        }
    }
}

