//
//  URLSessionHTTPClientTests.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 10/25/24.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void){
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://example.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url){ _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
        
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://example.com")!
        let error = NSError(domain: "Any Error", code: 1)
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url){ _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
        
    }
    
    // MARK: - Helpers
    
    class URLSessionSpy: URLSession {
        private var stubs: [URL: Stub] = [:]
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        
        func stub(url: URL, task: URLSessionDataTask = FakeURLSessionDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            guard let stub = stubs[url] else {
                fatalError("No stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            
            return stub.task
        }
    }
    
    class FakeURLSessionDataTask: URLSessionDataTask {
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
