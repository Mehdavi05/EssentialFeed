//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Shujaat-Hussain on 11/12/24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
