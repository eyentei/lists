//
//  LoginData.swift
//  lists
//
//  Created by Мария Коровина on 17.05.17.
//  Copyright © 2017 Мария Коровина. All rights reserved.
//

import Foundation
import RealmSwift

var user: User?
let username = "mailnya@yandex.ru"
let password = "qwe123"
let ip = "188.226.135.29:9080"
let realmURL = URL(string: "realm://\(ip)/~/lists")!
let authServerURL = URL(string: "http://\(ip)/")!

