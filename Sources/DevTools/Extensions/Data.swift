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
}
