//
//  Services.swift
//  Music Link
//
//  Created by uuttff8 on 9/4/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

struct ServiceProvider {
    var image: UIImage!
    var link: String!
    
    mutating func create(title: String, link: GenericPlatform?) -> ServiceProvider? {
        guard let link = link else { return nil }
        let image  = UIImage(named: title)!
        let linkk = link.url
        
        return ServiceProvider(image: image, link: linkk)
    }
}
