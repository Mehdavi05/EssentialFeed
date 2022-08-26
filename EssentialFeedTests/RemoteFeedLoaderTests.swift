//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init() {
        let url = URL(string: "https://any_test_url")!
        let(_, client) = makeSUT(url: url)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load{ _ in }
        sut.load{ _ in }
        
        XCTAssertEqual(client.requestedURLs.count, 2)
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load() {capturedErrors.append($0)}
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with:clientError, index:0)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200Response() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load() {capturedErrors.append($0)}
        
        client.complete(withStatusCode: 400)
        
        XCTAssertEqual(capturedErrors, [.invalidData])
    }
    
    //MARK: Helpers
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url:URL, completion:(Error?, HTTPURLResponse?) -> Void)]()
        
        var requestedURLs:[URL] {
            messages.map{$0.url}
        }

        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error:Error, index:Int = 0) -> Void {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code:Int, index:Int = 0) -> Void {
            let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)
            
            messages[index].completion(nil, response)
        }
    }
    
    private func makeSUT(url:URL = URL(string: "https://any_test_url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        
        return (sut, client)
        
    }
    
}
