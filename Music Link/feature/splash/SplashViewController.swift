//
//  SplashViewController.swift
//  Music Link
//
//  Created by uuttff8 on 9/11/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
    private var presenter = SplashPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension SplashViewController: SplashView {
    
}
