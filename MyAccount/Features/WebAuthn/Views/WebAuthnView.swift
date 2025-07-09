import SwiftUI
import AuthenticationServices

struct WebAuthnView: View {
    @EnvironmentObject var coordinator: LoginCoordinator
    @StateObject private var viewModel = WebAuthnViewModel()

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                // Header stays fixed
                HStack(alignment: .center) {
                    Text("WebAuthn Enrolments")
                        .font(.title)
                    Spacer()
                    Button(action: { coordinator.handleLogout() }) {
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.12))
                                .frame(width: 36, height: 36)
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .imageScale(.large)
                                .foregroundColor(.red)
                        }
                    }
                    .buttonStyle(.plain)
                }
                // Action stays fixed
                Button(action: {
                    Task { await viewModel.startRegistration(token: coordinator.token!) }
                }) {
                    Label("Add New Enrolment", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
                // Content scrolls
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView {
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage).foregroundColor(.red)
                        } else if viewModel.isLoading {
                            ProgressView()
                        } else if viewModel.enrolments.isEmpty {
                            Text("No enrolments found.")
                        } else {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(viewModel.enrolments) { enrolment in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("\(enrolment.nickname) \(enrolment.name)")
                                                    .font(.headline)
                                                Text("ID: \(enrolment.id)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                Text("Credential ID: \(enrolment.credentialId)")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Button(role: .destructive) {
                                                Task {
                                                    await viewModel.deleteEnrolment(token: coordinator.token!, id: enrolment.id)
                                                }
                                            } label: {
                                                Image(systemName: "trash")
                                            }
                                            .buttonStyle(.borderless)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.secondary.opacity(0.08))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 0)
                                    .padding(.vertical, 4)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    }
                }
                .frame(maxHeight: 400, alignment: .top)
                .onAppear {
                    Task { await viewModel.fetchEnrolments(token: coordinator.token!)}
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top) // Ensures content starts from the top

            if viewModel.shouldShowPasskeyDialog {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(1)
                    
                if let options = viewModel.registrationOptions {
                    PasskeyDialogView(
                        token: options.token,
                        challenge: options.challenge,
                        name: options.name,
                        userID: options.userID,
                        excludeCredentials: options.excludeCredentials,
                        userVerificationPreference: options.userVerificationPreference,
                        authenticatorAttachment: options.authenticatorAttachment,
                        publicKeyCredentialParameters: options.publicKeyCredentialParameters,
                        rpId: options.rpId,
                        onComplete: {
                            DispatchQueue.main.async {
                                viewModel.shouldShowPasskeyDialog = false
                                Task { await viewModel.fetchEnrolments(token: coordinator.token!) }
                            }
                        }
                    )
                    .frame(maxWidth: 400)
                    .padding()
                    .cornerRadius(12)
                    .shadow(radius: 20)
                    .zIndex(2)
                    .transition(.scale)
                } else {
                    ProgressView()
                        .zIndex(2)
                }
            }
        }
    }
}
