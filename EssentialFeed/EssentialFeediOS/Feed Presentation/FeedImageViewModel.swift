//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Shujaat-Hussain on 11/15/24.
//

import Foundation
import UIKit
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
