//
//  AppDelegate.swift
//  lists
//
//  Created by Мария Коровина on 11.02.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let defaults = UserDefaults.standard

        if defaults.bool(forKey: "isLoggedIn") {
            self.window?.rootViewController!.performSegue(withIdentifier: "segueToMain", sender: nil)
        }

        return true
    }
}
