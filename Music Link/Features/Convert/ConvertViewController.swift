//
//  ViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import CombineCocoa
import Combine

class ConvertViewController: ViewController {
    
    private lazy var contentView = ConvertViewUI()
    
    // NavBar Actions
    var aboutNavBarAction: UIBarButtonItem {
        UIBarButtonItem(image: UIImage(named: "about"), style: .plain, target: self, action: #selector(navigateToAbout))
    }
    
    var startNavBarAction: UIBarButtonItem {
        UIBarButtonItem(title: "Splash", style: .plain, target: self, action: #selector(navigateToStart))
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTargets()
        bindViewModel()
    }
    
    private func setUpTargets() {
        navigationItem.rightBarButtonItem = aboutNavBarAction
        navigationItem.leftBarButtonItem = startNavBarAction
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel as? ConvertViewModel else { return }
        
        let input = ConvertViewModel.Input(convertTriggered: contentView.convertButton.tapPublisher)
        let output = viewModel.transform(input)
        
        output.data
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if let response = response {
                    self.navigator.show(segue: .info(response), sender: self, transition: .present(true))
                } else {
                    let alert = UIAlertController(title: "Oops!", message: "Music link is not found in your pasteboard", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true, completion: nil)
                }
            }).store(in: &cancellable)
    }
    
    @objc private func navigateToStart() {
        Navigator.default.show(segue: .splash, sender: self, transition: .present(false))
    }
    
    @objc func navigateToAbout() {
        let vc = ScreenRouter.shared.getAboutController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
