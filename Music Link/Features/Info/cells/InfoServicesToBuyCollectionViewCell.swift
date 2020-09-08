//
//  InfoServicesToBuyCollectionViewCell.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 9/16/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class InfoServicesToBuyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewService: UIImageView!
    
    static var reuseId = "InfoServicesToBuyCollectionViewCell"
    
    func bind(service: ServiceProvider) {
        self.imageViewService.image = service.image
    }
}
