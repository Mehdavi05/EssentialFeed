//
//  URLSessionHTTPClientTests.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 10/25/24.
//

import XCTest

class URLSessionHTTPClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL){
        session.dataTask(with: url) { _, _, _ in }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "https://example.com")!
        let session = URLSessionSpy()
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedUrls, [url])
    }
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://example.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCallCount, 1)
        
    }
    
    // MARK: - Helpers
    
    class URLSessionSpy: URLSession {
        var receivedUrls:[URL] = []
        private var stubs = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task: URLSessionDataTask) {
            self.stubs[url] = task
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedUrls.append(url)
            return stubs[url] ?? FakeURLSessionTask()
        }
    }
    
    class FakeURLSessionTask: URLSessionDataTask {
        override func resume() {
            
        }
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0;
        
        override func resume() {
            resumeCallCount += 1
        }
    }
    
}
