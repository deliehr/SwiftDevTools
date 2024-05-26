//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation
import Network

public final class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = false
    @Published private(set) var isCellular = false

    private let nwMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue.global()

    static var shared = NetworkMonitor()

    func start() {
        nwMonitor.start(queue: workerQueue)

        nwMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isCellular = path.usesInterfaceType(.cellular)
            }
        }
    }

    func stop() {
        nwMonitor.cancel()
    }
}
