//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 10/22/24.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}
public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
