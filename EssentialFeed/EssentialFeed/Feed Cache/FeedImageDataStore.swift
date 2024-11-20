//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Shujaat-Hussain on 11/20/24.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
