//
//  Navigator.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/19/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    // MARK: - scenes list, all app scenes
    enum Scene {
        case tabs
        case splash
    }
    
    enum Transition {
        case root(in: UIWindow)
        case navigation
        case modal
        case detail
        case present
        case custom
    }
    
    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
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
            
            return musicLinkTabBarController
        case .splash: return SplashViewController(viewModel: nil, navigator: self)
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController(animated: true)
        }
    }

    func dismiss(sender: UIViewController) {
        sender.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }

    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = target
            }, completion: nil)
            return
        case .custom: return
        default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }
        
        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }

        switch transition {
        case .navigation:
            if let nav = sender.navigationController {
                nav.pushViewController(target, animated: true)
            }
        case .modal:
            // present modally
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: nil)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .present:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
        default: break
        }
    }
}
