//
//  File.swift
//  
//
//  Created by Dominik Liehr on 26.05.24.
//

import Foundation

class Throttler {
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private var job: (() -> Void)?
    private var previousRun: Date?
    private var workItem: DispatchWorkItem?

    init(seconds: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.interval = seconds
        self.queue = queue
    }

    func throttle(_ block: @escaping () -> Void) {
        job = block
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            self?.executeBlock()
        }

        if let previousRun = previousRun {
            let delay = Date().timeIntervalSince(previousRun) > interval ? 0 : interval
            queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
        } else {
            executeBlock()
        }
    }

    private func executeBlock() {
        previousRun = Date()
        job?()
        job = nil
    }
}
