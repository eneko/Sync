//
//  SyncTests.swift
//  Sync
//
//  Created by Eneko Alonso on 2/25/16.
//  Copyright © 2016 Eneko Alonso. All rights reserved.
//

import XCTest
import Sync
import CoreLocation

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

    func testCoreLocation() {
        let location = locationForString("San Francisco")
        XCTAssertEqual(Int(location?.coordinate.latitude ?? 0), 37)
        XCTAssertEqual(Int(location?.coordinate.longitude ?? 0), -122)
    }

    func locationForString(name: String) -> CLLocation? {
        var location: CLLocation?
        let sync = Sync()
        CLGeocoder().geocodeAddressString(name) { (placemarks, error) in
            location = placemarks?.first?.location
            sync.complete()
        }
        sync.wait(seconds: 5)
        return location
    }

}
