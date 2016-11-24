//
//  Sync.swift
//  Sync
//
//  Created by Eneko Alonso on 2/25/16.
//  Copyright © 2016 Eneko Alonso. All rights reserved.
//

public struct SyncBlock {

    fileprivate let semaphore: DispatchSemaphore

    public init() {
        semaphore = DispatchSemaphore(value: 0)
    }

    public func complete() {
        semaphore.signal()
    }

    public func wait(seconds timeout: TimeInterval = 0) {
        let start = Date()
        while semaphore.wait(timeout: DispatchTime.now()) == .timedOut {
            let intervalDate = Date(timeIntervalSinceNow: 0.01) // 10 msec
            RunLoop.current.run(until: intervalDate)
//            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: intervalDate)
            if timeout > 0 && Date().timeIntervalSince(start) > timeout {
                break
            }
        }
    }

}
