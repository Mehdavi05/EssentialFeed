//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        var requestedURLs = [URL]()
        
        func get(from url: URL) {
            requestedURL = url
            requestedURLs.append(url)
        }
    }
    
    func test_init() {
        let url = URL(string: "https://any_test_url")!
        let(_, client) = makeSUT(url: url)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
        
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs.count, 2)
    }
    
    //MARK: Helpers
    private func makeSUT(url:URL = URL(string: "https://any_test_url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        
        return (sut, client)
        
    }
    
}
