//
//  Constants.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

struct Constants {
    struct API {
        static let baseURL = "https://oie.tc2.okta.demesne.in"
        static let clientId = "0oafkco4d2UrtLrVI0w6"
        static let relyingPartyId = "oie.tc2.okta.demesne.in"
        static let apiVersion = "1.0.0"
    }
    
    struct OAuth {
        static let scope = "openid email profile offline_access okta.myAccount.webauthn.read okta.myAccount.webauthn.manage"
        static let grantType = "password"
    }
    
    struct WebAuthn {
        static let timeout: TimeInterval = 60
        static let userVerification = "required"
        static let attestation = "direct"
    }
    
    struct Keychain {
        static let service = "MyAccount"
        static let accessTokenKey = "access_token"
        static let refreshTokenKey = "refresh_token"
        static let userDataKey = "user_data"
    }
    
    struct UI {
        static let animationDuration: TimeInterval = 0.3
        static let cornerRadius: CGFloat = 8
        static let padding: CGFloat = 16
    }
}
