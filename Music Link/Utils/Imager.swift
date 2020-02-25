//
//  Imager.swift
//  Music Link
//
//  Created by uuttff8 on 9/3/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import Nuke

class Imager {
    
    static var shared = Imager()
    
    func loadImage(into: UIImageView, link: String?,  callBack: (() -> ())? = nil) {
        if link == nil { return }
        if let url = URL(string: link!) {
            
            Nuke.loadImage(with: url, into: into) { (_) in
                callBack?()
            }
        }
    }
}
