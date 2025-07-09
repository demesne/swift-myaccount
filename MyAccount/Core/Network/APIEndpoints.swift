//
//  APIEndpoints.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

enum APIEndpoints {
    case login
    case webAuthnEnrolments
    case webAuthnRegistration
    case webAuthnRegistrationComplete
    case deleteWebAuthnEnrolment(id: String)
    
    private var baseURL: String {
        return "https://oie.tc2.okta.demesne.in"
    }
    
    var url: URL {
        switch self {
        case .login:
            return URL(string: "\(baseURL)/oauth2/v1/token")!
        case .webAuthnEnrolments:
            return URL(string: "\(baseURL)/idp/myaccount/webauthn")!
        case .webAuthnRegistration:
            return URL(string: "\(baseURL)/idp/myaccount/webauthn/registration")!
        case .webAuthnRegistrationComplete:
            return URL(string: "\(baseURL)/idp/myaccount/webauthn")!
        case .deleteWebAuthnEnrolment(let id):
            return URL(string: "\(baseURL)/idp/myaccount/webauthn/\(id)")!
        }
    }
    
    var httpMethod: String {
        switch self {
        case .login, .webAuthnRegistration, .webAuthnRegistrationComplete:
            return "POST"
        case .webAuthnEnrolments:
            return "GET"
        case .deleteWebAuthnEnrolment:
            return "DELETE"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .login:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .webAuthnEnrolments, .webAuthnRegistration, .webAuthnRegistrationComplete:
            return ["Accept": "application/json;okta-version=1.0.0",
                    "Content-Type": "application/json"]
        case .deleteWebAuthnEnrolment:
            return ["Accept": "application/json;okta-version=1.0.0",
                    "Content-Type": "application/json"]
        }
    }
}
