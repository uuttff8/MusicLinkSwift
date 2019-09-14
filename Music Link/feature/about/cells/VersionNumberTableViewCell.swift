//
//  VersionNumberTableViewCell.swift
//  Music Link
//
//  Created by uuttff8 on 9/11/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class VersionNumberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var versionNumberLabel: UILabel!
    
    fileprivate func getVersionNumber() -> String {
        let versionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        let versionAndBuildNumber: String = versionNumber + "." + buildNumber
        
        return versionAndBuildNumber
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var reuseId: String = "VersionNumberTableViewCell"
    
}
