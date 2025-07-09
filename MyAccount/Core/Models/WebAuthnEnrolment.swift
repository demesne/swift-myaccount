//
//  WebAuthnEnrolment.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

struct WebAuthnEnrolment: Codable, Identifiable {
    let id: String
    let name: String
    let nickname: String?
    let credentialId: String
    let createdAt: Date?
    let lastUsedAt: Date?
    
    init(id: String, name: String, nickname: String?, credentialId: String, createdAt: Date? = nil, lastUsedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.nickname = nickname
        self.credentialId = credentialId
        self.createdAt = createdAt
        self.lastUsedAt = lastUsedAt
    }
    
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String
        self.credentialId = dictionary["credentialId"] as? String ?? ""
        self.createdAt = nil // TODO: Parse date if available
        self.lastUsedAt = nil // TODO: Parse date if available
    }
}
