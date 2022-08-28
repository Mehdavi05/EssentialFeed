//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion:@escaping (LoadFeedResult) -> Void)
}
