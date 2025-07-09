//
//  Base64URLConverter.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

struct Base64URLConverter {
    /// Converts a base64url-encoded string to a base64-encoded string
    static func base64urlToBase64(_ base64url: String) -> String {
        var base64 = base64url.replacingOccurrences(of: "-", with: "+")
                              .replacingOccurrences(of: "_", with: "/")
        
        // Add padding if needed
        let padding = 4 - base64.count % 4
        if padding < 4 {
            base64 += String(repeating: "=", count: padding)
        }
        
        return base64
    }
    
    /// Converts a base64-encoded string to a base64url-encoded string
    static func base64ToBase64url(_ base64: String) -> String {
        return base64.replacingOccurrences(of: "+", with: "-")
                    .replacingOccurrences(of: "/", with: "_")
                    .replacingOccurrences(of: "=", with: "")
    }
    
    /// Converts a base64url-encoded string to Data
    static func base64urlToData(_ base64url: String) -> Data? {
        let base64 = base64urlToBase64(base64url)
        return Data(base64Encoded: base64)
    }
    
    /// Converts Data to a base64url-encoded string
    static func dataToBase64url(_ data: Data) -> String {
        let base64 = data.base64EncodedString()
        return base64ToBase64url(base64)
    }
}
