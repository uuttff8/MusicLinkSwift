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
    
    // MARK: - UI
    var justLabel: UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 90)
        lbl.text = "Just Paste Link"
        lbl.textColor = UIColor.label
        lbl.sizeToFit()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        view.addSubview(lbl)
        return lbl
    }
    
    var convertButton: LoadingButton {
        let button = LoadingButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont().withSize(18)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.systemBlue
        button.setTitle("Convert", for: .normal)
        button.layer.cornerRadius = 8   
        view.addSubview(button)
        return button
    }
    
    // NavBar Actions
    var aboutNavBarAction: UIBarButtonItem {
        let item = UIBarButtonItem(image: UIImage(named: "about"), style: .plain, target: self, action: nil)
        item.tapPublisher.sink {
            let vc = ScreenRouter.shared.getAboutController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }.store(in: &cancellable)
        return item
    }
    
    var startNavBarAction: UIBarButtonItem {
        let item = UIBarButtonItem(title: "Start", style: .plain, target: self, action: nil)
        item.tapPublisher.sink {
            self.navigator.show(segue: .splash, sender: self, transition: .present(false))
        }.store(in: &cancellable)
        return item
    }
    
    // MARK: - Lifecycle
    override func makeUI() {
        super.makeUI()
        navigationItem.rightBarButtonItem = aboutNavBarAction
        navigationItem.leftBarButtonItem = startNavBarAction
        
        justLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        convertButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.equalTo(justLabel.snp.leading)
            make.trailing.equalTo(justLabel.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupContraints()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? ConvertViewModel else { return }
        let input = ConvertViewModel.Input(convertTriggered: convertButton.tapPublisher)
        let output = viewModel.transform(input)
        
        output.data
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if let response = response {
                    self.navigator.show(segue: .info(response), sender: self, transition: .present(true))
                } else {
                    let alert = UIAlertController(title: "Oops!", message: "music link is not found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true, completion: nil)
                }
            }).store(in: &cancellable)
    }
    
    // MARK: - Private UI
    fileprivate func setupContraints() {
        if (Display.typeIsLike == DisplayType.iphone5) {
            justLabel.font = justLabel.font.withSize(70)
        }
    }
}
