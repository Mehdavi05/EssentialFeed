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
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with:clientError, index:0)
        }
    }
    
    func test_load_deliversErrorOnNon200Response() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        let sampleCode = [199, 201, 300, 400, 500]
        
        sampleCode.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let json = makeItemsJson([])
                client.complete(withStatusCode: code, data: json, index: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ResponseWithInvalidJSONData() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data(_: "Invalid JSON".utf8);
            client.complete(withStatusCode: 200, data:invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmpthList() {
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data(_:"{\"items\":[]}".utf8);
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseCodeWithJSONItems() {
       
        let item1 = makeItem(id: UUID(), imageURL: URL(string: "https://a-url.com")!)
        
        let item2 = makeItem(id: UUID(), description: "BBQ On Beach", location: "Al-Mamzar Beach", imageURL: URL(string: "https://a-url.com")!)
        
        let items = [item1.model, item2.model]
        
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .success(items), when:{
            let json = makeItemsJson([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    //MARK: Helpers
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url:URL, completion:(HTTPClientResult) -> Void)]()
        
        var requestedURLs:[URL] {
            messages.map{$0.url}
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error:Error, index:Int = 0) -> Void {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code:Int, data: Data, index:Int = 0) -> Void {
            let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        
        let model = FeedItem (
           id: id,
           description: description,
           location: location,
           imageURL: imageURL
        )
        
        let json = [
            "id": id.uuidString,
            "description":description,
            "location":location,
            "image":imageURL.absoluteString
        ].reduce(into: [String: Any]()) {(acc, e) in
            if let value = e.value {
                acc[e.key] = value
            }
        }
        
        return (model, json);
        
    }
    
    private func makeItemsJson(_ items:[[String: Any]]) -> Data {
        let json = ["items":items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut:RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: ()->Void ,  file: StaticString = #filePath, line: UInt = #line) {
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load() {capturedResults.append($0)}
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeSUT(url:URL = URL(string: "https://any_test_url")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client:client)
        
        return (sut, client)
        
    }
    
}
