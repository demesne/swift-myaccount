//
//  PasskeyDialogView.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-06-14.
//

import SwiftUI
import AuthenticationServices

// MARK: - Custom AuthenticatorAttachment
/// A custom enum to represent authenticator attachment preference.
/// This allows for compatibility with older OS versions that do not have ASAuthorizationAuthenticatorAttachment.
// MARK: - Passkey Registration Options Parser
/// A helper struct to safely parse and hold the options for a passkey registration request.

// MARK: - Passkey Dialog Common Coordinator
public class PasskeyDialogCommonCoordinator: NSObject, ASAuthorizationControllerDelegate {
    public let token: String
    public let onComplete: () -> Void

    public init(token: String, onComplete: @escaping () -> Void) {
        self.token = token
        self.onComplete = onComplete
        super.init()
    }

    // `presentationAnchor` must be implemented by concrete subclasses (iOS vs macOS)
    // and cannot be part of the common coordinator as it returns platform-specific types.

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        defer { onComplete() } // Ensure onComplete is called.

        guard let credentialRegistration = authorization.credential as? ASAuthorizationPublicKeyCredentialRegistration else {
            print("[PasskeyDialogCommon] Authorization completed but credential is not a registration type.")
            return
        }
        
        let attestationObject = credentialRegistration.rawAttestationObject
        let clientDataJSON = credentialRegistration.rawClientDataJSON
        let credentialID = credentialRegistration.credentialID

        print("[PasskeyDialogCommon] Success: Got credential with ID: \(credentialID.base64EncodedString())")
        print("[PasskeyDialogCommon] ClientDataJSON (base64): \(clientDataJSON.base64EncodedString())")
        print("[PasskeyDialogCommon] AttestationObject (base64): \(attestationObject?.base64EncodedString() ?? "nil")")

        let payload: [String: Any] = [
            "attestation": attestationObject?.base64EncodedString() as Any,
            "clientData": clientDataJSON.base64EncodedString(),
        ]

        guard let url = URL(string: "https://oie.tc2.okta.demesne.in/idp/myaccount/webauthn") else {
            print("[PasskeyDialogCommon][Error] Invalid Okta URL.")
            return
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json;okta-version=1.0.0", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            print("[PasskeyDialogCommon][Error] Failed to serialize JSON payload: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("[PasskeyDialogCommon][Error] Okta enrollment POST failed: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("[PasskeyDialogCommon] Okta enrollment response status: \(httpResponse.statusCode)")
                    if let data = data, let str = String(data: data, encoding: .utf8) {
                        print("[PasskeyDialogCommon] Okta enrollment response body: \(str)")
                    }
                }
            }
        }
        task.resume()
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let authError = error as? ASAuthorizationError, authError.code == .canceled {
            print("[PasskeyDialogCommon] Authorization was canceled by the user.")
        } else {
            print("[PasskeyDialogCommon][Error] Authorization failed: \(error.localizedDescription)")
        }
        onComplete()
    }
}

// MARK: - Shared protocol for PasskeyDialogView
protocol PasskeyDialogViewProtocol: View {
    var token: String { get }
    var challenge: Data { get }
    var name: String { get }
    var userID: Data { get }
    var excludeCredentials: [Data] { get }
    var userVerificationPreference: ASAuthorizationPublicKeyCredentialUserVerificationPreference { get }
    var authenticatorAttachment: AuthenticatorAttachment? { get } // Use our custom enum
    var publicKeyCredentialParameters: [ASAuthorizationPublicKeyCredentialParameters] { get }
    var rpId: String { get } // Add rpId
    var onComplete: () -> Void { get }
}
