//  PasskeyDialogView+macOS.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-06-28.
#if os(macOS)
import SwiftUI
import AuthenticationServices
import AppKit

public struct PasskeyDialogView: NSViewControllerRepresentable {
    public let token: String
    public let challenge: Data
    public let name: String
    public let userID: Data
    public let excludeCredentials: [Data]
    public let userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference
    public let authenticatorAttachment: AuthenticatorAttachment?
    public let publicKeyCredentialParameters: [ASAuthorizationPublicKeyCredentialParameters]
    public let rpId: String
    public let onComplete: () -> Void

    public init(token: String, challenge: Data, name: String, userID: Data, excludeCredentials: [Data], userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference, authenticatorAttachment: AuthenticatorAttachment?, publicKeyCredentialParameters: [ASAuthorizationPublicKeyCredentialParameters], rpId: String, onComplete: @escaping () -> Void) {
        self.token = token
        self.challenge = challenge
        self.name = name
        self.userID = userID
        self.excludeCredentials = excludeCredentials
        self.userVerificationPreference = userVerificationPreference
        self.authenticatorAttachment = authenticatorAttachment
        self.publicKeyCredentialParameters = publicKeyCredentialParameters
        self.rpId = rpId
        self.onComplete = onComplete
    }

    public func makeNSViewController(context: Context) -> NSViewController {
        let controller = NSViewController()
        let registrationOptions = PasskeyRegistrationOptions(
            token: token,
            challenge: challenge,
            name: name,
            userID: userID,
            excludeCredentials: excludeCredentials,
            userVerificationPreference: userVerificationPreference,
            authenticatorAttachment: authenticatorAttachment,
            publicKeyCredentialParameters: publicKeyCredentialParameters,
            rpId: rpId
        )

        logDebug("RP ID: \(registrationOptions.rpId)", category: "PasskeyDialogView-macOS")
        logDebug("Challenge (base64): \(registrationOptions.challenge.base64EncodedString())", category: "PasskeyDialogView-macOS")
        logDebug("User Name: \(registrationOptions.name)", category: "PasskeyDialogView-macOS")
        logDebug("UserID (utf8): \(String(data: registrationOptions.userID, encoding: .utf8) ?? "<invalid utf8>")", category: "PasskeyDialogView-macOS")
        logDebug("UserID (base64): \(registrationOptions.userID.base64EncodedString())", category: "PasskeyDialogView-macOS")
        logDebug("Authenticator Attachment: \(registrationOptions.authenticatorAttachment?.rawValue ?? "nil")", category: "PasskeyDialogView-macOS")
        logDebug("Public Key Credential Parameters: \(registrationOptions.publicKeyCredentialParameters.map { $0.algorithm.rawValue })", category: "PasskeyDialogView-macOS")

        DispatchQueue.main.async {
            var requests: [ASAuthorizationRequest] = []

            // Check for OS availability for Passkey APIs
            if #available(macOS 12.0, *) {
                // --- Platform Authenticator (e.g., Touch ID) ---
                if registrationOptions.authenticatorAttachment == .platform || registrationOptions.authenticatorAttachment == nil {
                    let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: registrationOptions.rpId)
                    let request = provider.createCredentialRegistrationRequest(challenge: registrationOptions.challenge, name: registrationOptions.name, userID: registrationOptions.userID)
                    
                    if !registrationOptions.excludeCredentials.isEmpty {
                        //request.excludedCredentials = registrationOptions.excludeCredentials.map { ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: $0) }
                    }
                    request.userVerificationPreference = registrationOptions.userVerificationPreference
                    requests.append(request)
                    logDebug("Created ASAuthorizationPlatformPublicKeyCredentialRegistrationRequest", category: "PasskeyDialogView-macOS")
                }

                // --- Security Key Authenticator (Cross-Platform) ---
                if registrationOptions.authenticatorAttachment == .crossPlatform || registrationOptions.authenticatorAttachment == nil {
                    let provider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: registrationOptions.rpId)
                    let request = provider.createCredentialRegistrationRequest(challenge: registrationOptions.challenge, displayName: registrationOptions.name, name: registrationOptions.name, userID: registrationOptions.userID)

                    // Ensure publicKeyCredentialParameters are set for Security Key requests
                    if !registrationOptions.publicKeyCredentialParameters.isEmpty {
                        request.credentialParameters = registrationOptions.publicKeyCredentialParameters
                    } else {
                        logWarning("No publicKeyCredentialParameters provided for Security Key. Using default ES256 (-7)", category: "PasskeyDialogView-macOS")
                        request.credentialParameters = [ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier(rawValue: -7))]
                    }

                    if !registrationOptions.excludeCredentials.isEmpty {
                        //request.excludedCredentials = excludeCredentials.map { ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor(credentialID: $0, transports: []) }
                    }
                    request.attestationPreference = .direct
                    request.userVerificationPreference = registrationOptions.userVerificationPreference
                    requests.append(request)
                    logDebug("Created ASAuthorizationSecurityKeyPublicKeyCredentialRegistrationRequest", category: "PasskeyDialogView-macOS")
                }
            } else {
                logError("Passkey registration APIs require macOS 12.0+", category: "PasskeyDialogView-macOS")
                onComplete()
                return
            }

            if requests.isEmpty {
                logError("No authorization requests were created. Check 'authenticatorAttachment' value or OS version", category: "PasskeyDialogView-macOS")
                onComplete()
                return
            }

            logDebug("Performing \(requests.count) authorization request(s)...", category: "PasskeyDialogView-macOS")
            let authController = ASAuthorizationController(authorizationRequests: requests)
            authController.presentationContextProvider = context.coordinator
            authController.delegate = context.coordinator
            authController.performRequests()
        }

        return controller
    }

    public func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        return Coordinator(token: token, onComplete: onComplete)
    }

    // MARK: - Coordinator for macOS
    public class Coordinator: PasskeyDialogCommonCoordinator, ASAuthorizationControllerPresentationContextProviding {
        public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            NSApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
        }
    }
}
#endif
