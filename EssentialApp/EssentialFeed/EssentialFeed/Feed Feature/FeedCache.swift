//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Shujaat-Hussain on 11/21/24.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
