//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Shujaat-MacBook on 9/3/22.
//

import XCTest

class LocalFeedStore {
    init(store: FeedStore) {
        
    }
}

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedStore(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
