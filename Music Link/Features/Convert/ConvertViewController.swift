//
//  ViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

class ConvertViewController: ViewController {
    
    @IBOutlet weak var pasteButton: LoadingButton!
    @IBOutlet weak var justLabel: UILabel!
    
    fileprivate func setupContraints() {
        if (Display.typeIsLike == DisplayType.iphone5) {
            justLabel.font = justLabel.font.withSize(70)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupContraints()
    }
    
    lazy var convertButton: LoadingButton = {
        let button = LoadingButton()
        button.backgroundColor = UIColor.systemBlue
        button.originalButtonText = "Convert"
        button.layer.cornerRadius = 8
        view.addSubview(button)
        return button
    }()
    
    lazy var aboutNavBarAction: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(named: "about"), style: .plain, target: self, action: #selector(self.navigateToAbout))
        return item
    }()
    
    @objc func navigateToAbout() {
        let vc = ScreenRouter.shared.getAboutController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var startNavBarAction: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(self.navigateToStart))
        return item
    }()
    
    @objc func navigateToStart() {
        navigator.show(segue: .splash, sender: self, transition: .present)
    }
    
    override func makeUI() {
        super.makeUI()
        
        navigationItem.rightBarButtonItem = aboutNavBarAction
        navigationItem.leftBarButtonItem = startNavBarAction
        
        convertButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }
    
    
}

// MARK: - Extension
extension ConvertViewController {
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
