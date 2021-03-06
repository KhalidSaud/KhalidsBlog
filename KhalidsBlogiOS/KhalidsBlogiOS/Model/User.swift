//
//  User.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 24/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let email, password: String
}

struct UserToSend: Codable {
    let email, password: String
}
