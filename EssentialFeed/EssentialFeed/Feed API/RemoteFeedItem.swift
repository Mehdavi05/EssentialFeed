//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 11/4/24.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
