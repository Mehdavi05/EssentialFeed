//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Shujaat-Hussain on 11/20/24.
//


public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}