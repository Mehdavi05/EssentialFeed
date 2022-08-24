//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import XCTest

protocol HTTPClient {
    func get(from url:URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteFeedLoader {
    let client:HTTPClient
    let url:URL
    
    init(url:URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: self.url)
    }
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init() {
        let url = URL(string: "https://any_test_url")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://any_test_url")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
        
    }
    
}
