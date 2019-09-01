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
    private var isActiveLoading = false
    
    @IBOutlet weak var pasteButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onCreate(view: self)
    }
    
    deinit {
        presenter.onDestroy()
    }
    
    @IBAction func pasteButtonPressed(_ sender: LoadingButton) {
        if (!isActiveLoading) {
           sender.showLoading()
            isActiveLoading = true

            presenter.startConvertingToLink()
        } else {
            sender.hideLoading()
            isActiveLoading = false
        }
    }
}

// MARK: - Extension
extension ConvertViewController: ConvertView {
    func showError(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showLoading(isLoading: Bool) {
        print("Loading: ---------")
    }
    
    func hidePasteButtonLoading() {
        pasteButton.hideLoading()
    }
    
    func onConvertedLink(links: LinksResponse) {
        self.present(ScreenRouter.shared.getInfoController(links: links), animated: true, completion: nil)
    }
}
