//
//  MainTabBarController.swift
//  Music Link
//
//  Created by uuttff8 on 9/8/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class MusicLinkTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIApplication.isFirstLaunch() {
            Navigator.default.show(segue: .splash, sender: self, transition: .present(true))
        }
    }
}
