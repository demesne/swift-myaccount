//
//  CredentialsApp.swift
//  Credentials
//
//  Created by Kumar Abhinav on 2025-06-14.
//

import SwiftUI

@main
struct MyAccountApp: App {
    @StateObject private var loginCoordinator = LoginCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginCoordinator)
        }
    }
}
