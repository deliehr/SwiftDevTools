//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

extension Int64 {
    func asDateString(_ format: String) -> String {
        Date(timeIntervalSince1970: TimeInterval(self/1000)).asString(format)
    }
}
