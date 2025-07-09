//
//  NetworkManager.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }
    
    func login(username: String, password: String) async throws -> AuthToken {
        let params = [
            "grant_type": "password",
            "username": username,
            "password": password,
            "scope": "openid email profile offline_access okta.myAccount.webauthn.read okta.myAccount.webauthn.manage",
            "client_id": "0oafkco4d2UrtLrVI0w6"
        ]
        
        let body = params.map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        let (data, _) = try await httpClient.performRequest(
            endpoint: .login,
            body: body,
            headers: nil
        )
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let accessToken = json["access_token"] as? String else {
            throw AuthError.invalidResponse
        }
        
        return AuthToken(
            accessToken: accessToken,
            tokenType: json["token_type"] as? String ?? "Bearer",
            expiresIn: json["expires_in"] as? Int,
            refreshToken: json["refresh_token"] as? String,
            scope: json["scope"] as? String
        )
    }
    
    func fetchWebAuthnEnrolments(token: String) async throws -> [WebAuthnEnrolment] {
        let (data, _) = try await httpClient.performRequest(
            endpoint: .webAuthnEnrolments,
            body: nil,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        guard let array = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw AuthError.invalidResponse
        }
        return array.map { WebAuthnEnrolment(from: $0) }
    }
    
    func startWebAuthnRegistration(token: String) async throws -> WebAuthnRegistrationOptions {
        let (data, _) = try await httpClient.performRequest(
            endpoint: .webAuthnRegistration,
            body: nil,
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let optionsDict = json["options"] as? [String: Any] else {
            throw AuthError.invalidResponse
        }
        logDebug("WebAuthn options: \(optionsDict)")
        let optionsData = try JSONSerialization.data(withJSONObject: optionsDict)
        let decoder = JSONDecoder()
        return try decoder.decode(WebAuthnRegistrationOptions.self, from: optionsData)
    }
    
    func completeWebAuthnRegistration(token: String, attestation: String, clientData: String) async throws {
        let payload = [
            "attestation": attestation,
            "clientData": clientData
        ]
        
        let body = try JSONSerialization.data(withJSONObject: payload)
        
        let _ = try await httpClient.performRequest(
            endpoint: .webAuthnRegistrationComplete,
            body: body,
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
    
    func deleteWebAuthnEnrolment(token: String, id: String) async throws {
        _ = try await httpClient.performRequest(
            endpoint: .deleteWebAuthnEnrolment(id: id),
            body: nil,
            headers: ["Authorization": "Bearer \(token)"]
        )
    }
}
