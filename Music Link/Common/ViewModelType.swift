//
//  ViewModelType.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/17/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import Logging
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

class ViewModel: NSObject {
    
    let logger = Logger(label: "com.uuttff.musiclink")
    
    deinit {
        logger.info("\(type(of: self)): Deinited")
    }
}
