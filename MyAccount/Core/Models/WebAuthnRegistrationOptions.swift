//
//  WebAuthnRegistrationOptions.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation
import AuthenticationServices

struct WebAuthnRegistrationOptions: Codable {
    let challenge: String
    let timeout: Int?
    var rp: RP
    let user: WebAuthnUser
    let pubKeyCredParams: [PublicKeyCredentialParameters]?
    let excludeCredentials: [PublicKeyCredentialDescriptor]?
    let authenticatorSelection: AuthenticatorSelectionCriteria?
    let attestation: String?
    let u2fParams: U2FParams?
    let extensions: Extensions?

    struct RP: Codable {
        var id: String?
        let name: String?
    }
    struct WebAuthnUser: Codable {
        let id: String // Change from let to var
        let name: String
        let displayName: String
    }
    struct PublicKeyCredentialParameters: Codable {
        let type: String
        let alg: Int
    }
    struct PublicKeyCredentialDescriptor: Codable {
        let type: String
        let id: String
        let transports: [String]?
    }
    struct AuthenticatorSelectionCriteria: Codable {
        let authenticatorAttachment: String?
        let requireResidentKey: Bool?
        let residentKey: String?
        let userVerification: String?
    }
    struct U2FParams: Codable {
        let appid: String?
    }
    struct Extensions: Codable {
        let credProps: Bool?
    }
}
