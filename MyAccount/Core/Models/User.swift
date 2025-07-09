//
//  User.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let email: String?
    let displayName: String?
    
    init(id: String, username: String, email: String? = nil, displayName: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.displayName = displayName
    }
}
