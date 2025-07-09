//
//  Data+Extensions.swift
//  MyAccount
//
//  Created by Kumar Abhinav on 2025-07-07.
//

import Foundation

extension Data {
    /// Convert Data to a base64url-encoded string
    var base64URLEncodedString: String {
        return Base64URLConverter.dataToBase64url(self)
    }
    
    /// Create Data from a base64url-encoded string
    init?(base64URLEncoded string: String) {
        guard let data = Base64URLConverter.base64urlToData(string) else {
            return nil
        }
        self = data
    }
    
    /// Convert Data to a hexadecimal string
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    /// Create Data from a hexadecimal string
    init?(hexString: String) {
        let cleanedString = hexString.replacingOccurrences(of: " ", with: "")
        guard cleanedString.count.isMultiple(of: 2) else { return nil }
        
        var data = Data(capacity: cleanedString.count / 2)
        var index = cleanedString.startIndex
        
        for _ in 0..<cleanedString.count/2 {
            let nextIndex = cleanedString.index(index, offsetBy: 2)
            let hexByte = String(cleanedString[index..<nextIndex])
            guard let byte = UInt8(hexByte, radix: 16) else { return nil }
            data.append(byte)
            index = nextIndex
        }
        
        self = data
    }
}
