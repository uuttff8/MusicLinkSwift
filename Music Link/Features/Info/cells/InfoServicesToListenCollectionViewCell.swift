//
//  InfoServiceCollectionViewCell.swift
//  Music Link
//
//  Created by uuttff8 on 9/3/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class InfoServicesToListenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageViewService: UIImageView!
    
    static var reuseId: String = "InfoServicesToListenCollectionViewCell"
    
    func bind(service: ServiceProvider) {
        self.imageViewService.image = service.image
    }
}
