//
//  DataInputStream.swift
//  DevTools
//
//  Created by Dominik Liehr on 12.11.24.
//

import Foundation

public class DataInputStream {
    private let inputStream: InputStream
    
    public init?(url: URL) {
        if let stream = InputStream(url: url) {
            self.inputStream = stream
        } else {
            return nil
        }
    }
    
    public func open() {
        inputStream.open()
    }
    
    public func close() {
        inputStream.close()
    }
    
    public func readAll() -> [Data] {
        var blocks = [Data]()
        
        while true {
            // read length
            var lengthBuffer = [UInt8](repeating: 0, count: MemoryLayout<UInt32>.size)
            let bytesRead = inputStream.read(&lengthBuffer, maxLength: lengthBuffer.count)
            
            if bytesRead == 0 {
                // end of stream
                break
            } else if bytesRead < 0 {
                if let error = inputStream.streamError {
                    debugPrint(error.localizedDescription)
                }
                break
            } else if bytesRead < lengthBuffer.count {
                debugPrint("uncomplete length detected")
                break
            }
            
            // convert length of big-endian
            let lengthData = Data(lengthBuffer)
            var length: UInt32 = 0
            
            _ = lengthData.withUnsafeBytes { buffer in
                length = buffer.load(as: UInt32.self)
            }
            
            length = UInt32(bigEndian: length)
            
            // read data depending on length
            var dataBuffer = [UInt8](repeating: 0, count: Int(length))
            var totalBytesRead = 0
            
            while totalBytesRead < dataBuffer.count {
                let bytesToRead = dataBuffer.count - totalBytesRead
                let bytesRead = inputStream.read(&dataBuffer[totalBytesRead], maxLength: bytesToRead)
                
                if bytesRead <= 0 {
                    if let error = inputStream.streamError {
                        debugPrint("data read error: \(error.localizedDescription)")
                    }
                    break
                }
                
                totalBytesRead += bytesRead
            }
            
            if totalBytesRead == dataBuffer.count {
                let block = Data(dataBuffer)
                
                blocks.append(block)
            } else {
                debugPrint("could not read all data")
                break
            }
        }
        
        return blocks
    }
    
    public func read(completion: @escaping (Data)->Void) {
        while true {
            // read length
            var lengthBuffer = [UInt8](repeating: 0, count: MemoryLayout<UInt32>.size)
            let bytesRead = inputStream.read(&lengthBuffer, maxLength: lengthBuffer.count)
            
            if bytesRead == 0 {
                // end of stream
                break
            } else if bytesRead < 0 {
                if let error = inputStream.streamError {
                    debugPrint(error.localizedDescription)
                }
                break
            } else if bytesRead < lengthBuffer.count {
                debugPrint("uncomplete length detected")
                break
            }
            
            // convert length of big-endian
            let lengthData = Data(lengthBuffer)
            var length: UInt32 = 0
            
            _ = lengthData.withUnsafeBytes { buffer in
                length = buffer.load(as: UInt32.self)
            }
            
            length = UInt32(bigEndian: length)
            
            // read data depending on length
            var dataBuffer = [UInt8](repeating: 0, count: Int(length))
            var totalBytesRead = 0
            
            while totalBytesRead < dataBuffer.count {
                let bytesToRead = dataBuffer.count - totalBytesRead
                let bytesRead = inputStream.read(&dataBuffer[totalBytesRead], maxLength: bytesToRead)
                
                if bytesRead <= 0 {
                    if let error = inputStream.streamError {
                        debugPrint("data read error: \(error.localizedDescription)")
                    }
                    break
                }
                
                totalBytesRead += bytesRead
            }
            
            if totalBytesRead == dataBuffer.count {
                let block = Data(dataBuffer)
                
                completion(block)
            } else {
                debugPrint("could not read all data")
                break
            }
        }
    }
    
    public func read() -> AsyncStream<Data> {
        return AsyncStream { continuation in
            while true {
                // read length
                var lengthBuffer = [UInt8](repeating: 0, count: MemoryLayout<UInt32>.size)
                let bytesRead = inputStream.read(&lengthBuffer, maxLength: lengthBuffer.count)
                
                if bytesRead == 0 {
                    // end of stream
                    break
                } else if bytesRead < 0 {
                    if let error = inputStream.streamError {
                        debugPrint(error.localizedDescription)
                    }
                    break
                } else if bytesRead < lengthBuffer.count {
                    debugPrint("uncomplete length detected")
                    break
                }
                
                // convert length of big-endian
                let lengthData = Data(lengthBuffer)
                var length: UInt32 = 0
                
                _ = lengthData.withUnsafeBytes { buffer in
                    length = buffer.load(as: UInt32.self)
                }
                
                length = UInt32(bigEndian: length)
                
                // read data depending on length
                var dataBuffer = [UInt8](repeating: 0, count: Int(length))
                var totalBytesRead = 0
                
                while totalBytesRead < dataBuffer.count {
                    let bytesToRead = dataBuffer.count - totalBytesRead
                    let bytesRead = inputStream.read(&dataBuffer[totalBytesRead], maxLength: bytesToRead)
                    
                    if bytesRead <= 0 {
                        if let error = inputStream.streamError {
                            debugPrint("data read error: \(error.localizedDescription)")
                        }
                        break
                    }
                    
                    totalBytesRead += bytesRead
                }
                
                if totalBytesRead == dataBuffer.count {
                    let block = Data(dataBuffer)
                    
                    continuation.yield(block)
                } else {
                    debugPrint("could not read all data")
                    break
                }
            }
            
            continuation.finish()
        }
    }
}
