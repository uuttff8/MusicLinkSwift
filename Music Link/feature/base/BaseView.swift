//
//  BaseView.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

protocol BaseView {
    func showError(text: String)
}

protocol NetView {
    func showError(text: String)
    func showLoading(isLoading: Bool)
}
