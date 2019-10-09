//
//  SplashViewModel.swift
//  Music Link
//
//  Created by uuttff8 on 9/11/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol SplashViewModelInput {
    var continueAction: CocoaAction { get }
    // var playVideoAction: CocoaAction { get }
}

protocol SplashViewModelOuput {
    // var buttonName: Observable<String> { get }
}

protocol SplashViewModelType {
    var inputs: SplashViewModelInput { get }
    var outputs: SplashViewModelOuput { get }
}

class SplashViewModel: NSObject, SplashViewModelInput, SplashViewModelOuput, SplashViewModelType {
    
    // MARK: - Inputs & Outputs
    var inputs: SplashViewModelInput { return self }
    var outputs: SplashViewModelOuput { return self }
    
    // MARK: - Input
    
    lazy var continueAction: CocoaAction = {
        return CocoaAction { [unowned self] _ in
            self.navigateToTabBar()
        }
    }()
    
    private let sceneCoordinator: SceneCoordinatorType
    
    private func navigateToTabBar() -> Observable<Void> {
        print("TO DO IT \(#line)")
        return .empty()
    }
    
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        super.init()
    }
}
