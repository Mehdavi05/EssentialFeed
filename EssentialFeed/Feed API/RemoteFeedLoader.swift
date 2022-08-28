//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 8/25/22.
//

import Foundation

public final class RemoteFeedLoader {
    private let client:HTTPClient
    private let url:URL
    
    public enum Error:Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url:URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion:@escaping (Result) -> Void) {
        client.get(from: self.url) { result in
            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, fromResponse: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
    
    private static func map(_ data:Data, fromResponse response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, response)
            return .success(items)
        }
        catch {
            return .failure(.invalidData)
        }
    }
}

