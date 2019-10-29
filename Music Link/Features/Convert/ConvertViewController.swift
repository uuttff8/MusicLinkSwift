//
//  ViewController.swift
//  Music Link
//
//  Created by uuttff8 on 8/29/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit
import RxSwift

class ConvertViewController: ViewController {
    
    @IBOutlet weak var pasteButton: LoadingButton!
        
    lazy var justLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 90)
        lbl.text = "Just Paste Link"
        lbl.textColor = UIColor.label
        lbl.sizeToFit()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        view.addSubview(lbl)
        return lbl
    }()
    
    // in rxswift version, i dont release loading button with loading action
    lazy var convertButton: LoadingButton = {
        let button = LoadingButton()
        button.backgroundColor = UIColor.systemBlue
        button.setTitle("Convert", for: .normal)
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
        navigator.show(segue: .splash, sender: self, transition: .present(false))
    }
    
    fileprivate func setupContraints() {
        if (Display.typeIsLike == DisplayType.iphone5) {
            justLabel.font = justLabel.font.withSize(70)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeUI() {
        super.makeUI()
        setupContraints()
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
    
    override func bindViewModel() {
        super.bindViewModel()
        
        guard let viewModel = viewModel as? ConvertViewModel else { return }
        let input = ConvertViewModel.Input(convertTriggered: convertButton.rx.tap.asSignal())
        let output = viewModel.transform(input)
        
        output.data.drive(onNext: { [weak self] response in
            guard let self = self else { return }
            
            if let response = response {
                self.navigator.show(segue: .info(response), sender: self, transition: .present(true))
            } else {
                let alert = UIAlertController(title: "Oops!", message: "Login failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: rx.disposeBag)
        
        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            let alert = UIAlertController(title: "!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self!.present(alert, animated: true, completion: nil)
            
        }).disposed(by: rx.disposeBag)
    }
}
