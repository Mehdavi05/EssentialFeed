//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 10/22/24.
//

import Foundation

public struct FeedImage: Hashable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}