//
//  XCTestCase-MemoryLeakTrackingHelper.swift
//  EssentialFeedTests
//
//  Created by Shujaat-MacBook on 8/31/22.
//

import XCTest

extension XCTestCase {
    public func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, potential memory leak", file: file, line: line)
        }
    }
}
