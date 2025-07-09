//
//  AuthService.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-06-28.
//

import Foundation

protocol AuthService {
    func login(username: String, password: String) async throws -> AuthToken
    func logout() async throws
    func refreshToken(refreshToken: String) async throws -> AuthToken
}

class AuthServiceImpl: AuthService {
    private let networkManager: NetworkManager
    private let keychainService: KeychainService
    
    init(networkManager: NetworkManager = NetworkManager.shared, keychainService: KeychainService = KeychainServiceImpl()) {
        self.networkManager = networkManager
        self.keychainService = keychainService
    }
    
    func login(username: String, password: String) async throws -> AuthToken {
        let token = try await networkManager.login(username: username, password: password)
        
        // Save token to keychain
        try saveToken(token)
        
        return token
    }
    
    func logout() async throws {
        // Clear tokens from keychain
        try keychainService.delete(key: Constants.Keychain.accessTokenKey)
        try keychainService.delete(key: Constants.Keychain.refreshTokenKey)
    }
    
    func refreshToken(refreshToken: String) async throws -> AuthToken {
        // TODO: Implement token refresh logic
        throw AuthError.unknown
    }
    
    private func saveToken(_ token: AuthToken) throws {
        let tokenData = try JSONEncoder().encode(token)
        try keychainService.save(key: Constants.Keychain.accessTokenKey, data: tokenData)
    }
}