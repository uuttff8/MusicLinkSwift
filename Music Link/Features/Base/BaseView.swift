//
//  BaseView.swift
//  Music Link
//
//  Created by uuttff8 on 8/30/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

protocol BaseView {
    func showError(title: String, message: String?)
}

protocol NetView {
    func showError(title: String, message: String?)
    func isLoading(_ isLoading: Bool)
}

