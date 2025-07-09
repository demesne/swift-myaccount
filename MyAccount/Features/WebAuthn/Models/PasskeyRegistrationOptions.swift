//
//  PasskeyRegistrationOptions.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation
import AuthenticationServices

struct PasskeyRegistrationOptions {
    let token: String
    let challenge: Data
    let name: String
    let userID: Data
    let excludeCredentials: [Data]
    let userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference
    let authenticatorAttachment: AuthenticatorAttachment?
    let publicKeyCredentialParameters: [ASAuthorizationPublicKeyCredentialParameters]
    let rpId: String

    init(token: String, challenge: Data, name: String, userID: Data, excludeCredentials: [Data], userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference, authenticatorAttachment: AuthenticatorAttachment?, publicKeyCredentialParameters: [ASAuthorizationPublicKeyCredentialParameters], rpId: String) {
        self.token = token
        self.challenge = challenge
        self.name = name
        self.userID = userID
        self.excludeCredentials = excludeCredentials
        self.userVerificationPreference = userVerificationPreference
        self.authenticatorAttachment = authenticatorAttachment
        self.publicKeyCredentialParameters = publicKeyCredentialParameters
        self.rpId = rpId
    }
}
