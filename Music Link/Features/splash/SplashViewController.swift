//
//  SplashViewController.swift
//  Music Link
//
//  Created by uuttff8 on 9/11/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SplashViewController: BaseViewController {
    
    private var presenter = SplashPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "start_video", ofType:"MP4") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }

    @IBAction func continueButtonPressed(_ sender: RoundButton) {
       let vc = ScreenRouter.shared.getMainTabBarController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        playVideo()
    }
}


extension SplashViewController: SplashView {
    
}
