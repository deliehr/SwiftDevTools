//
//  UserDefaults.swift
//  DevTools
//
//  Created by Dominik Liehr on 11.11.24.
//

import Foundation

public extension UserDefaults {
    func keyExists(_ key: String) -> Bool {
        self.dictionaryRepresentation().keys.contains("key")
    }
}
