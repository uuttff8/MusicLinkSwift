//
//  StackView.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/23/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class StackView: UIStackView {    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        axis = .vertical
        // self.distribution = .fill

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
