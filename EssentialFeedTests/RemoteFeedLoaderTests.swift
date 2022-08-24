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
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        func get(from url: URL) {
            requestedURL = url
        }
    }
    
    
    func test_init() {
        let url = URL(string: "https://any_test_url")!
        let(_, client) = makeSUT(url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
        
    }
    
    //MARK: Helpers
    private func makeSUT(url:URL = URL(string: "https://any_test_url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        
        return (sut, client)
        
    }
    
}
