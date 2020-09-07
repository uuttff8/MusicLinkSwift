//
//  HistoryTableViewCell.swift
//  Music Link
//
//  Created by uuttff8 on 9/13/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

struct HistoryCellModel: Equatable, Hashable {
    let label: String!
    let image: String!
    
    var description: String {
        return
            "Name: \(String(describing: label))\n" +
            "Image: \(String(describing: image))\n"
    }
}


class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    
    func bind(data: HistoryCellModel) {
        Imager.shared.loadImage(into: self.songImageView, link: data.image)
        self.songLabel.text = data.label
        configureUi()
    }
    
    private func configureUi() {
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.systemBackground.cgColor
    }
}
