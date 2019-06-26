//
//  Blog.swift
//  KhalidsBlogiOS
//
//  Created by KHALID ALSUBAIE on 22/06/2019.
//  Copyright © 2019 Arabic Technologies. All rights reserved.
//

import Foundation

struct Blog: Codable {
    let id: Int
    let title: String
    let imageName: String?
    let content: String
}

struct BlogToSend: Codable {
    let title: String
    let imageName: String?
    let content: String
}
