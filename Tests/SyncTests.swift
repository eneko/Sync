//
//  SyncTests.swift
//  Sync
//
//  Created by Eneko Alonso on 2/25/16.
//  Copyright © 2016 Eneko Alonso. All rights reserved.
//

import XCTest
import Sync

class SyncTests: XCTestCase {
    
    func testWithoutBlock() {
        let sync = Sync()
        sync.complete()
        sync.wait()
        XCTAssertTrue(true)
    }

    func testAsyncBlockMainThread() {
        var count = 0
        let sync = Sync()
        XCTAssertEqual(count, 0)
        dispatch_async(dispatch_get_main_queue()) {
            XCTAssertEqual(++count, 2)
            sync.complete()
        }
        XCTAssertEqual(++count, 1)
        sync.wait()
        XCTAssertEqual(++count, 3)
    }

    func testAsyncBlockBackgroundThread() {
        var count = 0
        let sync = Sync()
        XCTAssertEqual(count, 0)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            XCTAssertEqual(++count, 2)
            sync.complete()
        }
        XCTAssertEqual(++count, 1)
        sync.wait()
        XCTAssertEqual(++count, 3)
    }

}
