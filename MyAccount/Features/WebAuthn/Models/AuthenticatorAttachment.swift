//
//  AuthenticatorAttachment.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

/// A custom enum to represent authenticator attachment preference.
/// This allows for compatibility with older OS versions that do not have ASAuthorizationAuthenticatorAttachment.
public enum AuthenticatorAttachment: String, CaseIterable {
    case platform = "platform"
    case crossPlatform = "cross-platform"
    
    var displayName: String {
        switch self {
        case .platform:
            return "Platform Authenticator"
        case .crossPlatform:
            return "Cross-Platform Authenticator"
        }
    }
}
