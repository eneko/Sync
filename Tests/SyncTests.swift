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
        let sync = SyncBlock()
        sync.complete()
        sync.wait()
        XCTAssertTrue(true)
    }

    func testAsyncBlockMainThread() {
        var count = 0
        let sync = SyncBlock()
        XCTAssertEqual(count, 0)
        DispatchQueue.main.async {
            XCTAssertEqual(++count, 2)
            sync.complete()
        }
        XCTAssertEqual(++count, 1)
        sync.wait()
        XCTAssertEqual(++count, 3)
    }

    func testAsyncBlockBackgroundThread() {
        var count = 0
        let sync = SyncBlock()
        XCTAssertEqual(count, 0)
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
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

    func locationForString(_ name: String) -> CLLocation? {
        var location: CLLocation?
        let sync = SyncBlock()
        CLGeocoder().geocodeAddressString(name) { (placemarks, error) in
            location = placemarks?.first?.location
            sync.complete()
        }
        sync.wait(seconds: 5)
        return location
    }

}
