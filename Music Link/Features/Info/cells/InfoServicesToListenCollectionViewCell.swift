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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
