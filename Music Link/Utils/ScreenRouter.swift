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
        case ABOUT = "About"
        case SPLASH = "Splash"
    }
    
    public enum CONTROLLERS: String {
        // Main
        case CONVERT = "ConvertViewController"
        case HISTORY = "HistoryViewController"
        case TAB_BAR = "MainTabBarController"
        
        // Info
        case INFO = "InfoViewController"
        
        // Settings
        case ABOUT = "AboutViewController"
        
        // Splash
        case SPLASH = "SplashViewController"
    }
    
    func getInfoController(links: LinksResponse?) -> InfoViewController {
        let controller = initiate(board: getStoryboard(board: .INFO), name: .INFO) as! InfoViewController
        controller.links = links
        return controller
    }
    
    func getConvertController() -> ConvertViewController {
        return initiate(board: getStoryboard(board: .MAIN), name: .CONVERT) as! ConvertViewController
    }
    
    func getHistoryController() -> HistoryViewController {
        return initiate(board: getStoryboard(board: .MAIN), name: .HISTORY) as! HistoryViewController
    }
    
    func getAboutController() -> AboutViewController {
        return initiate(board: getStoryboard(board: .ABOUT), name: .ABOUT) as! AboutViewController
    }
    
    func getSplashController() -> SplashViewController {
        return initiate(board: getStoryboard(board: .SPLASH), name: .SPLASH) as! SplashViewController
    }
    
    private func getStoryboard(board: STORYBOARDS) -> UIStoryboard {
        return UIStoryboard(name: board.rawValue, bundle: nil)
    }
    
    private func initiate(board: UIStoryboard, name: CONTROLLERS) -> UIViewController {
        return board.instantiateViewController(withIdentifier: name.rawValue)
    }
}
