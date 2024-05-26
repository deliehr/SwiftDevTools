//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()

        self.dateFormat = format
    }
}
