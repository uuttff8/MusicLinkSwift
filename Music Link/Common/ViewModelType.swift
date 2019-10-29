//
//  ViewModelType.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/17/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import Foundation
import Logging
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

class ViewModel: NSObject {
    
    let logger = Logger(label: "com.uuttff.musiclink")
    let error = ErrorTracker()
    
    deinit {
        logger.info("\(type(of: self)): Deinited")
        #if DEBUG
        logger.info("RxSwift resources count: \("N") \(#line)") // RxSwift should supprt RxSwiftTest framework
        #endif
    }
}
