//
//  ViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class ConvertViewController: BaseViewController {
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
    
    @IBAction func gearNavBarActionPressed(_ sender: UIBarButtonItem) {
        let vc = ScreenRouter.shared.getAboutController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extension
extension ConvertViewController: ConvertView {    
    func showError(text: String) {
        let alert = UIAlertController.createOkAlert(text: text)
        self.present(alert, animated: true, completion: nil)
    }
    func showLoading(isLoading: Bool) {
        print("Loading: ---------")
    }
    
    func hidePasteButtonLoading() {
        pasteButton.hideLoading()
        pasteButton.isEnabled = true
    }
    
    func onConvertedLink(links: LinksResponse) {
        self.navigationController?.pushViewController(ScreenRouter.shared.getInfoController(links: links), animated: true)
    }
}
