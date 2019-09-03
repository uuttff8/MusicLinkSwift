//
//  Imager.swift
//  Music Link
//
//  Created by uuttff8 on 9/3/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import SDWebImage

class Imager {
    
    static var shared = Imager()
    
    func loadImage(into: UIImageView, link: String?,  callBack: (() -> ())? = nil) {
        if link == nil { return }
        if let url = URL(string: link!) {
            
            into.sd_setImage(with: url,
                             placeholderImage: UIImage(named: "placeholder"),
                             options: .progressiveLoad)
            { (image, error, type, url) in
                callBack?()
            }
        }
    }
}
