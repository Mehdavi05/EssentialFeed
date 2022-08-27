//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 8/24/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
