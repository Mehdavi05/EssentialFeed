//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Shujaat-Hussain on 11/20/24.
//

import Foundation
import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel!
    
    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }
        
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        label.text = nil
    }
}
