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
                client.complete(withStatusCode: code, index: index)
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
         let item1 = FeedItem (
            id: UUID(),
            description: nil,
            location: nil,
            imageURL: URL(string: "https://a-url.com")!
         )
       
        let jsonItem1 = [
            "id": item1.id.uuidString,
            "image":item1.imageURL.absoluteString
        ]
        
        let item2 = FeedItem (
           id: UUID(),
           description: "BBQ On Beach",
           location: "AlMamzar Beach",
           imageURL: URL(string: "https://a-url.com")!
        )
      
       let jsonItem2 = [
           "id": item2.id.uuidString,
           "description":item2.description,
           "location":item2.location,
           "image":item2.imageURL.absoluteString
       ]
        
        let itemsJSON = [
            "items":[jsonItem1, jsonItem2]
        ]
        
        let items = [item1, item2]
        
        let url = URL(string: "https://any_test_url")!
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .success(items), when:{
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
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
        
        func complete(withStatusCode code:Int, data: Data = Data(), index:Int = 0) -> Void {
            let response = HTTPURLResponse(url: messages[index].url, statusCode: code, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
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
