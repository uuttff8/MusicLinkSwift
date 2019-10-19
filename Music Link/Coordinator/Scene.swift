//
//  Scene.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/9/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

/**
     Refers to a screen managed by a view controller.
     It can be a regular screen, or a modal dialog.
     It comprises a view controller and a view model.
 */

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

private enum TabBarControllers: Int {
    case Convert
    case History
}

enum Scene {
    case tabs
    case splash
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .tabs:
            let musicLinkTabBarController = MusicLinkTabBarController()
            
            // ConvertViewController
            let convertVC = ScreenRouter.shared.getConvertController()
            let rootConvertVC = UINavigationController(rootViewController: convertVC)
            
            // HistoryViewController
            let historyVC = ScreenRouter.shared.getHistoryController()
            
            let convertTabBarItem = UITabBarItem(
                title: "Convert",
                image: UIImage(named: "itunes")!,
                tag: 0
            )
            let historyTabBarItem = UITabBarItem(
                title: "History",
                image: UIImage(named: "format_list_bulleted")!,
                tag: 1
            )
            
            convertVC.tabBarItem = convertTabBarItem
            historyVC.tabBarItem = historyTabBarItem
            
            musicLinkTabBarController.viewControllers = [
                rootConvertVC,
                historyVC
            ]
            
            return .tabBar(musicLinkTabBarController)
        case .splash:
            let vc = SplashViewController()
            return .present(vc)
        }
    }
}


