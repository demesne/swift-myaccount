import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    var onLoginSuccess: ((String, String) -> Void)?

    private let authService: AuthService

    init(authService: AuthService = AuthServiceImpl()) {
        self.authService = authService
    }

    func loginToOkta() async {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password required"
            return
        }
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        do {
            let token = try await authService.login(username: username, password: password)
            onLoginSuccess?(username, token.accessToken)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
