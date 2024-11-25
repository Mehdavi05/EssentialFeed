//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Shujaat-Hussain on 11/25/24.
//

import UIKit

extension UIView {
    
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
