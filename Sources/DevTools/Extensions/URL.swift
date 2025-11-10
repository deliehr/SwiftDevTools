//
//  URL.swift
//  DevTools
//
//  Created by Dominik on 10.11.25.
//

import Foundation

public extension URL {
    enum FileLocation {
        case iCloud
        case appGroup
        case appDocuments
        case external
    }
    
    var fileLocation: FileLocation {
        let path = standardizedFileURL.path.lowercased()
        
        if path.contains("com~apple~clouddocs") {
            return .iCloud
        }
        
        if path.contains("/private/var/mobile/containers/shared/appgroup") {
            return .appGroup
        }
        
        if isInsideAppContainer {
            return .appDocuments
        }
        
        return .external
    }
    
    var needsSecurityScopedAccess: Bool {
        return switch fileLocation {
        case .iCloud, .external: true
        case .appGroup, .appDocuments: false
        }
    }
    
    private var isInsideAppContainer: Bool {
        let fm = FileManager.default
        let u = standardizedFileURL
        
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first
        let lib = fm.urls(for: .libraryDirectory, in: .userDomainMask).first
        let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first
        let tmp = fm.temporaryDirectory
        
        func hasPrefix(_ base: URL?) -> Bool {
            guard let base else { return false }
            
            return u.path.hasPrefix(base.standardizedFileURL.path)
        }
        
        return hasPrefix(docs) || hasPrefix(lib) || hasPrefix(caches) || u.path.hasPrefix(tmp.standardizedFileURL.path)
    }
    
//    private func withSecurityScopedAccessIfNeeded<T>(_ block: () throws -> T) rethrows -> T {
//        if needsSecurityScopedAccess {
//            let ok = startAccessingSecurityScopedResource()
//            defer { if ok { stopAccessingSecurityScopedResource() } }
//            return try block()
//        } else {
//            return try block()
//        }
//    }
}
