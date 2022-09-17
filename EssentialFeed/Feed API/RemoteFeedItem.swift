//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 9/17/22.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
