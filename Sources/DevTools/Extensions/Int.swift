//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

public extension Int64{
    func asDateString(_ format: String) -> String {
        Date(timeIntervalSince1970: TimeInterval(self)).asString(format)
    }
}

public extension Int32 {
    func asDateString(_ format: String) -> String {
        Date(timeIntervalSince1970: TimeInterval(self)).asString(format)
    }
}

public extension Int {
    func asDateString(_ format: String) -> String {
        Date(timeIntervalSince1970: TimeInterval(self)).asString(format)
    }
}
