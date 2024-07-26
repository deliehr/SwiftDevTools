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

    @available(iOS 16, *)
    func fileSize(atPath path: URL) throws -> Int64? {
        guard path.isFileURL else { throw FileMethodError.invalidFileScheme }

        return try fileSize(atPath: path.path())
    }

    func fileSize(atPath path: String) throws -> Int64? {
        let attriubtes = try FileManager.default.attributesOfItem(atPath: path)

        guard let bytes = attriubtes[.size] as? Int64 else { return nil }

        return bytes
    }
}

enum FileMethodError: Error {
    case invalidFileScheme
}
