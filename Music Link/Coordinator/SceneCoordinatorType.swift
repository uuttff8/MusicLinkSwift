//
//  SceneCoordinatorType.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/9/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    @discardableResult func transition(to scene: TargetScene) -> Observable<Void>
    @discardableResult func pop(animated: Bool) -> Observable<Void>
}


