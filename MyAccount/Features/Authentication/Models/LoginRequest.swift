//
//  LoginRequest.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

struct LoginRequest {
    let username: String
    let password: String
    let grantType: String
    let scope: String
    let clientId: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.grantType = Constants.OAuth.grantType
        self.scope = Constants.OAuth.scope
        self.clientId = Constants.API.clientId
    }
    
    var parameters: [String: String] {
        return [
            "grant_type": grantType,
            "username": username,
            "password": password,
            "scope": scope,
            "client_id": clientId
        ]
    }
}
