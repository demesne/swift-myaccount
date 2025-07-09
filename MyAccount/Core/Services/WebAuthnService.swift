//
//  WebAuthnService.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation
import AuthenticationServices

protocol WebAuthnService {
    func fetchEnrolments(token: String) async throws -> [WebAuthnEnrolment]
    func startRegistration(token: String) async throws -> WebAuthnRegistrationOptions
    func completeRegistration(token: String, attestation: String, clientData: String) async throws
    func deleteEnrolment(token: String, id: String) async throws
}

class WebAuthnServiceImpl: WebAuthnService {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchEnrolments(token: String) async throws -> [WebAuthnEnrolment] {
        return try await networkManager.fetchWebAuthnEnrolments(token: token)
    }
    
    func startRegistration(token: String) async throws -> WebAuthnRegistrationOptions {
        return try await networkManager.startWebAuthnRegistration(token: token)
    }
    
    func completeRegistration(token: String, attestation: String, clientData: String) async throws {
        try await networkManager.completeWebAuthnRegistration(token: token, attestation: attestation, clientData: clientData)
    }
    
    func deleteEnrolment(token: String, id: String) async throws {
        try await networkManager.deleteWebAuthnEnrolment(token: token, id: id)
    }
}
