//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation
import Network
import Combine
import SwiftUI

@available(iOS 17, OSX 14, *)
@MainActor
@Observable
public final class NetworkMonitor {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitor", qos: .userInitiated)
    
    public var isConnected: Bool? = nil
    public var usedInterface: NWInterface.InterfaceType? = nil
    
    @ObservationIgnored
    public private(set) var isConnectedPub = PassthroughSubject<Bool,Never>()
    
    @ObservationIgnored
    public private(set) var usedInterfacePub = PassthroughSubject<NWInterface.InterfaceType,Never>()
    
    public static let shared = NetworkMonitor()
    
    private init() {
        networkMonitor.pathUpdateHandler = { path in
            Task.detached(priority: .userInitiated) { [path] in
                let newStatus = path.status == .satisfied
                await self.updateConnectedIfNecessary(newStatus)
                
                
                let usesCellular = path.usesInterfaceType(.cellular)
                let usesWifi = path.usesInterfaceType(.wifi)
                let usesEthernet = path.usesInterfaceType(.wiredEthernet)
                
                if usesCellular {
                    await self.updateUsedInterfaceIfNecessary(.cellular)
                } else if usesWifi {
                    await self.updateUsedInterfaceIfNecessary(.wifi)
                } else if usesEthernet {
                    await self.updateUsedInterfaceIfNecessary(.wiredEthernet)
                } else {
                    await self.updateUsedInterfaceIfNecessary(.other)
                }
            }
        }
        
        networkMonitor.start(queue: workerQueue)
    }
    
    private func updateConnectedIfNecessary(_ connected: Bool) {
        guard self.isConnected != connected else { return }
        
        self.isConnected = connected
        isConnectedPub.send(connected)
    }
    
    private func updateUsedInterfaceIfNecessary(_ interface: NWInterface.InterfaceType) {
        guard self.usedInterface != interface else { return }
        
        self.usedInterface = interface
        self.usedInterfacePub.send(interface)
    }
    
    public func start() {
        isConnectedPub = PassthroughSubject<Bool,Never>()
        usedInterfacePub = PassthroughSubject<NWInterface.InterfaceType,Never>()
        networkMonitor.start(queue: workerQueue)
    }
    
    public func stop() {
        networkMonitor.cancel()
        isConnectedPub.send(completion: .finished)
        usedInterfacePub.send(completion: .finished)
    }
}

