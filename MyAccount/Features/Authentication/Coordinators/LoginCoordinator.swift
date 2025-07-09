//
//  LoginCoordinator.swift
//  Credentials
//
//  Created by Kumar Abhinav on 2025-06-28.
//


import Foundation
import SwiftUI
import Combine

final class LoginCoordinator: ObservableObject {
    @Published var isLoggedIn = false
    @Published var username: String?
    @Published var token: String?

    func handleLogin(username: String, token: String) {
        self.username = username
        self.token = token
        self.isLoggedIn = true
    }
    
    func handleLogout() {
        self.username = nil
        self.token = nil
        self.isLoggedIn = false
    }
}
