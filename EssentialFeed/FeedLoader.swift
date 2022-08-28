//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error:Swift.Error
    
    func load(completion:@escaping (LoadFeedResult<Error>) -> Void)
}
