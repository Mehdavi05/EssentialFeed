//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Shujaat-Hussain on 11/15/24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
