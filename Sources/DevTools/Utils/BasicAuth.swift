//
//  BasicAuth.swift
//  DevTools
//
//  Created by Dominik Liehr on 01.07.25.
//

import Foundation

public func createBasicAuthHeaderValue(username: String, password: String) -> String? {
    guard let credentialData = "\(username):\(password)".data(using: .utf8) else { return nil }
    
    let base64Credentials = credentialData.base64EncodedString()
    
    return "Basic \(base64Credentials)"
}
