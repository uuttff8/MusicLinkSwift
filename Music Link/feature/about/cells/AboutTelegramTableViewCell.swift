//
//  AboutTelegramTableViewCell.swift
//  Music Link
//
//  Created by uuttff8 on 9/14/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class AboutTelegramTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            let url = "https://t.me/uuttff8"
            if let url = URL(string: url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        // Configure the view for the selected state
    }

}
