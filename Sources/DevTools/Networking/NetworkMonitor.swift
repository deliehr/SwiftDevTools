//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation
import Network

@available(iOS 17, OSX 14, *)
@Observable
public final class NetworkMonitor {
    public var isConnected = false
    public var isCellular = false

    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()

    public static var shared = NetworkMonitor()

    public func start() {
        nwMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isCellular = path.usesInterfaceType(.cellular)
            }
        }

        nwMonitor.start(queue: workerQueue)
    }

    public func stop() {
        nwMonitor.cancel()
    }
}
