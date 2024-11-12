//
//  Semaphore.swift
//  DevTools
//
//  Created by Dominik Liehr on 05.11.24.
//

import Foundation

@available(OSX 10.15, *)
actor Semaphore {
    private var count: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []
    
    init(count: Int = 0) {
        self.count = count
    }
    
    func wait() async {
        count -= 1
        if count >= 0 { return }
        await withCheckedContinuation {
            waiters.append($0)
        }
    }
    
    func release(count: Int = 1) {
        assert(count >= 1)
        self.count += count
        for _ in 0..<count {
            if waiters.isEmpty { return }
            waiters.removeFirst().resume()
        }
    }
}
