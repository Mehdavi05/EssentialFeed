//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 9/16/22.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp:Date, completion:@escaping InsertionCompletion)
    func retrieve()
}
