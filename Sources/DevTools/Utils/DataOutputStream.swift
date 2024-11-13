//
//  DataOutputStream.swift
//  DevTools
//
//  Created by Dominik Liehr on 12.11.24.
//

import Foundation

public class DataOutputStream {
    let outputStream: OutputStream
    
    public init?(url: URL) {
        if let stream = OutputStream(url: url, append: false) {
            outputStream = stream
        } else {
            return nil
        }
    }
    
    public func open() {
        outputStream.open()
    }
    
    public func close() {
        outputStream.close()
    }
    
    public func append(data: Data) {
        var length = UInt32(data.count).bigEndian
        
        withUnsafeBytes(of: &length) { lengthBuffer in
            outputStream.write(lengthBuffer.bindMemory(to: UInt8.self).baseAddress!, maxLength: MemoryLayout<UInt32>.size)
        }
        
        data.withUnsafeBytes { dataBuffer in
            outputStream.write(dataBuffer.bindMemory(to: UInt8.self).baseAddress!, maxLength: data.count)
        }
    }
}
