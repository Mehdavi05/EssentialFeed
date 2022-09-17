//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Shujaat-MacBook on 8/28/22.
//

import Foundation

internal class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items:[RemoteFeedItem]
    }

    static var OK_200: Int { return 200 }
    
    internal static func map(_ data:Data, fromResponse response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
