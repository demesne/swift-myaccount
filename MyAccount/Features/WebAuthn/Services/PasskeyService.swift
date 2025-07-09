//
//  PasskeyService.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation
import AuthenticationServices

protocol PasskeyService {
    func createRegistrationOptions(from serverOptions: WebAuthnRegistrationOptions, token: String) -> PasskeyRegistrationOptions
    func parseRegistrationResponse(_ response: ASAuthorizationPublicKeyCredentialRegistration) -> (attestation: String, clientData: String)
}

class PasskeyServiceImpl: PasskeyService {
    func createRegistrationOptions(from serverOptions: WebAuthnRegistrationOptions, token: String) -> PasskeyRegistrationOptions {
        let challengeData = Base64URLConverter.base64urlToData(serverOptions.challenge) ?? Data()
        let userIDData = serverOptions.user.id.data(using: .utf8) ?? Data()
        let excludeCredentials = serverOptions.excludeCredentials?.compactMap { credential in
            Base64URLConverter.base64urlToData(credential.id)
        } ?? []
        
        let userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference = {
            switch serverOptions.authenticatorSelection?.userVerification {
            case "required":
                return .required
            case "preferred":
                return .preferred
            case "discouraged":
                return .discouraged
            default:
                return .preferred
            }
        }()
        
        let authenticatorAttachment = serverOptions.authenticatorSelection?.authenticatorAttachment.flatMap {
            AuthenticatorAttachment(rawValue: $0)
        }
        
        let publicKeyCredentialParameters: [ASAuthorizationPublicKeyCredentialParameters] = serverOptions.pubKeyCredParams!.compactMap { param in
            if #available(iOS 15.0, macOS 12.0, *) {
                return ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier(param.alg))
            } else {
                return nil
            }
        }
        
        return PasskeyRegistrationOptions(
            token: token,
            challenge: challengeData,
            name: serverOptions.user.name,
            userID: userIDData,
            excludeCredentials: excludeCredentials,
            userVerificationPreference: userVerificationPreference,
            authenticatorAttachment: authenticatorAttachment,
            publicKeyCredentialParameters: publicKeyCredentialParameters,
            rpId: (serverOptions.rp.id)!
        )
    }
    
    func parseRegistrationResponse(_ response: ASAuthorizationPublicKeyCredentialRegistration) -> (attestation: String, clientData: String) {
        let attestationObject = response.rawAttestationObject?.base64EncodedString() ?? ""
        let clientDataJSON = response.rawClientDataJSON.base64EncodedString()
        
        logDebug("Parsed registration response - Attestation: \(attestationObject), ClientData: \(clientDataJSON)", category: "PasskeyService")
        
        return (attestation: attestationObject, clientData: clientDataJSON)
    }
}
