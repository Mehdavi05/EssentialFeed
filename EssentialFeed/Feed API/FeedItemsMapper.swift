//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 8/28/22.
//

import Foundation

internal class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items:[Item]
        
        var feed: [FeedItem] {
            return items.map{$0.item}
        }
    }

    internal struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    static var OK_200: Int { return 200 }
    
    internal static func map(_ data:Data, fromResponse response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            return .failure(.invalidData)
        }
        
        return .success(root.feed)
    }
}
