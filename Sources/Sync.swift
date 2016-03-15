//
//  Sync.swift
//  Sync
//
//  Created by Eneko Alonso on 2/25/16.
//  Copyright © 2016 Eneko Alonso. All rights reserved.
//

public struct SyncBlock {

    private let semaphore: dispatch_semaphore_t

    public init() {
        semaphore = dispatch_semaphore_create(0)
    }

    public func complete() {
        dispatch_semaphore_signal(semaphore)
    }

    public func wait(seconds timeout: NSTimeInterval = 0) {
        let start = NSDate()
        while dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW) != 0 {
            let intervalDate = NSDate(timeIntervalSinceNow: 0.01) // 10 msec
            NSRunLoop.currentRunLoop().runUntilDate(intervalDate)
//            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: intervalDate)
            if timeout > 0 && NSDate().timeIntervalSinceDate(start) > timeout {
                break
            }
        }
    }

}
