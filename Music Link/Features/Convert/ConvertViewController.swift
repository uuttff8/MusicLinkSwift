//
//  ViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class ConvertViewController: UIViewController {
    private var presenter = ConvertPresenter()
    
    @IBOutlet weak var pasteButton: LoadingButton!
    @IBOutlet weak var justLabel: UILabel!
    
    fileprivate func setupContraints() {
        if (Display.typeIsLike == DisplayType.iphone5) {
            justLabel.font = justLabel.font.withSize(70)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onCreate(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupContraints()
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    @IBAction func pasteButtonPressed(_ sender: LoadingButton) {
        pasteButton.isEnabled = false
        sender.showLoading()
        presenter.startConvertingToLink()
    }
    
    @IBAction func aboutNavBarActionPressed(_ sender: UIBarButtonItem) {
        let vc = ScreenRouter.shared.getAboutController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func startNavBarActionPressed(_ sender: UIBarButtonItem) {
        //SceneCoordinator.shared.transition(to: Scene.splash)
        Navigator.default.show(segue: .splash, sender: self, transition: .present)
    }
}

// MARK: - Extension
extension ConvertViewController: ConvertView {
    func showError(title: String, message: String?) {
        let alert = UIAlertController.createOkAlert(title: title, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    func isLoading(_ isLoading: Bool) {
        
    }
    
    func hidePasteButtonLoading() {
        pasteButton.hideLoading()
        pasteButton.isEnabled = true
    }
    
    func onConvertedLink(links: LinksResponse) {
        let vc = UINavigationController(rootViewController: ScreenRouter.shared.getInfoController(links: links))
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        }
        self.present(vc, animated: true)
    }
}
