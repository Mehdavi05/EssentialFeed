//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Shujaat-Hussain on 11/20/24.
//

import UIKit

extension UIRefreshControl {
    
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
