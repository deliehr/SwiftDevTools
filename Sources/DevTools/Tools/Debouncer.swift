//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

public class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue

    public init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }
    
    public func debounce(action: @escaping (() -> Void)) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil
        }
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
