//
//  MultipartFile.swift
//  
//
//  Created by Dominik Liehr on 25.07.24.
//

import Foundation

public struct MultipartFile {
    public var key: String
    public var name: String
    public var mimeType: String
    public var content: Data

    public init(key: String, name: String, mimeType: String, content: Data) {
        self.key = key
        self.name = name
        self.mimeType = mimeType
        self.content = content
    }
}
