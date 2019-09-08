//
//  ScreenRouter.swift
//  Music Link
//
//  Created by uuttff8 on 8/31/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class ScreenRouter {
    static var shared = ScreenRouter()
    
    private enum STORYBOARDS: String {
        case MAIN = "Main"
        case INFO = "Info"
    }
    
    public enum CONTROLLERS: String {
        // Main
        case CONVERT = "ConvertViewController"
        case HISTORY = "HistoryViewController"
        case TAB_BAR = "MainTabBarController"
        
        // Info
        case INFO = "InfoViewController"
    }
    
    func getInfoController(links: LinksResponse?) -> InfoViewController {
        let controller = initiate(board: getStoryboard(board: .INFO), name: .INFO) as! InfoViewController
        controller.links = links
        return controller
    }
    
    func getConvertController() -> ConvertViewController {
        return initiate(board: getStoryboard(board: .MAIN), name: .CONVERT) as! ConvertViewController
    }
    
    func getMainTabBarController() -> MainTabBarController {
        return initiate(board: getStoryboard(board: .MAIN), name: .TAB_BAR) as! MainTabBarController
    }
    
    
    private func getStoryboard(board: STORYBOARDS) -> UIStoryboard {
        return UIStoryboard(name: board.rawValue, bundle: nil)
    }
    
    private func initiate(board: UIStoryboard, name: CONTROLLERS) -> UIViewController {
        return board.instantiateViewController(withIdentifier: name.rawValue)
    }
}
