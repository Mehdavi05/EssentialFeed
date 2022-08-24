//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import XCTest

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoader {
    
}
class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init() {
         let client = HTTPClient()
         _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
}
