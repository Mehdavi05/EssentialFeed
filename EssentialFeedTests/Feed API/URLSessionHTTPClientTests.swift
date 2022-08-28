//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Shujaat-MacBook on 8/28/22.
//

import XCTest

class URLSessionHTTPClient {
    
    let session:URLSession
    
    init(session: URLSession){
        self.session = session
    }
    
    func get(from url:URL) {
        session.dataTask(with: url) { _, _, _ in}
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "https://any_url.com")!
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from:url)
        
        XCTAssertEqual(session.receivedUrls, [url])
    }
    
    private class URLSessionSpy: URLSession {
        var receivedUrls = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedUrls.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        
    }
}
