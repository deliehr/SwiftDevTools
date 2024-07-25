//
//  FileManager.swift
//
//
//  Created by Dominik Liehr on 25.07.24.
//

import Foundation

public extension FileManager {
    func fileExists(atPath path: String, isDirectory: Bool) -> Bool {
        var fileIsDirectory: ObjCBool = ObjCBool(isDirectory)

        return FileManager.default.fileExists(atPath: path, isDirectory: &fileIsDirectory)
    }

    func directoryExists(atPath path: String) -> Bool {
        self.fileExists(atPath: path, isDirectory: true)
    }
}
