import Combine
import SwiftUI
import Foundation
import AuthenticationServices

class WebAuthnViewModel: ObservableObject {
    @Published var enrolments: [WebAuthnEnrolment] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var shouldShowPasskeyDialog = false

    @Published var registrationOptions: PasskeyRegistrationOptions?
    @Published var registrationChallenge: Data?
    @Published var registrationUserName: String?
    @Published var registrationUserID: Data?
    @Published var registrationAuthenticatorAttachment: AuthenticatorAttachment?
    @Published var registrationPubKeyCredParams: [ASAuthorizationPublicKeyCredentialParameters]?

    private let webAuthnService: WebAuthnService
    private let passkeyService: PasskeyService

    init(webAuthnService: WebAuthnService = WebAuthnServiceImpl(), passkeyService: PasskeyService = PasskeyServiceImpl()) {
        self.webAuthnService = webAuthnService
        self.passkeyService = passkeyService
    }

    @MainActor
    func fetchEnrolments(token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            enrolments = try await webAuthnService.fetchEnrolments(token: token)
            logInfo("Successfully fetched \(enrolments.count) enrolments", category: "WebAuthn")
        } catch {
            logError("Failed to fetch enrolments: \(error)", category: "WebAuthn")
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func startRegistration(token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            var serverOptions = try await webAuthnService.startRegistration(token: token)
            serverOptions.rp.id = serverOptions.rp.id ?? "oie.tc2.okta.demesne.in"
            let registrationOptions = passkeyService.createRegistrationOptions(from: serverOptions, token: token)
            
            self.registrationOptions = registrationOptions
            self.registrationChallenge = registrationOptions.challenge
            self.registrationUserName = registrationOptions.name
            self.registrationUserID = registrationOptions.userID
            self.registrationAuthenticatorAttachment = registrationOptions.authenticatorAttachment
            self.registrationPubKeyCredParams = registrationOptions.publicKeyCredentialParameters
            
            shouldShowPasskeyDialog = true
            logInfo("Started registration process", category: "WebAuthn")
        } catch {
            logError("Failed to start registration: \(error)", category: "WebAuthn")
            errorMessage = error.localizedDescription
        }
    }
    
    func completeRegistration(token: String, response: ASAuthorizationPublicKeyCredentialRegistration) async {
        let (attestation, clientData) = passkeyService.parseRegistrationResponse(response)
        
        do {
            try await webAuthnService.completeRegistration(token: token, attestation: attestation, clientData: clientData)
            logInfo("Successfully completed registration", category: "WebAuthn")
        } catch {
            logError("Failed to complete registration: \(error)", category: "WebAuthn")
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func deleteEnrolment(token: String, id: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await webAuthnService.deleteEnrolment(token: token, id: id)
            enrolments.removeAll { $0.id == id }
        } catch {
            logError("Failed to delete enrolment: \(error)", category: "WebAuthn")
            errorMessage = error.localizedDescription
        }
    }
}
