//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}
protocol FeedLoader {
    func load(completion:@escaping (LoadFeedResult) -> Void)
}
