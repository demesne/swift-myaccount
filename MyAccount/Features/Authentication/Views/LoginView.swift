//
//  LoginView.swift
//  Credentials
//
//  Created by Kumar Abhinav on 2025-06-28.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var coordinator: LoginCoordinator
    @ObservedObject private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Text("Login").font(.largeTitle)
            VStack(spacing: 10) { // Reduced spacing for tighter layout
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 20))
                    .frame(maxWidth: 300)
                // Changed SecureField to use a more appropriate label
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 20))
                    .frame(maxWidth: 300)
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                // Add padding before the login button
                Spacer().frame(height: 16)
                LoadingButton(title: "Log In", isLoading: viewModel.isLoading) {
                    Task { await viewModel.loginToOkta() }
                }
                .frame(maxWidth: 300)
                .disabled(viewModel.isLoading)
            }
            .frame(maxWidth: 400)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .onAppear {
            viewModel.onLoginSuccess = { username, token in
                coordinator.handleLogin(username: username, token: token)
            }
        }
    }
}

#if DEBUG
#Preview {
    LoginView()
        .environmentObject(LoginCoordinator())
}
#endif
