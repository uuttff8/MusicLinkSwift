//
//  ViewController.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/19/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var viewModel: ViewModel?
    var navigator: Navigator!
    
    var cancellable = Set<AnyCancellable>()

    init(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
}
