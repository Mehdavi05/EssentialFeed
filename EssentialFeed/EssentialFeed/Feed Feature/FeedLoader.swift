//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 10/22/24.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
