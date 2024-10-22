//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 10/22/24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}
