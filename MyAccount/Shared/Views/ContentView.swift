//
//  ContentView.swift
//  Credentials
//
//  Created by Kumar Abhinav on 2025-06-14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginCoordinator: LoginCoordinator

    var body: some View {
        Group {
            if loginCoordinator.isLoggedIn {
                WebAuthnView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
