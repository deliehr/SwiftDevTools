//
//  Data.swift
//
//
//  Created by Dominik Liehr on 25.07.24.
//

import Foundation

public extension Data {
    mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        guard let data = string.data(using: encoding) else { return }

        append(data)
    }
    
    /// Use in consunction with application(_:didRegisterForRemoteNotificationsWithDeviceToken:)
    var deviceTokenString: String {
        let tokenParts = map { String(format: "%02.2hhx", $0) }
        let token = tokenParts.joined()
        
        return token
    }
}
