//
//  ConvertViewUI.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 2/25/20.
//  Copyright © 2020 uuttff8. All rights reserved.
//

import UIKit

class ConvertViewUI: View {

    // MARK: - UI
    lazy var justLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 90)
        lbl.text = "Just Paste Link"
        lbl.textColor = UIColor.label
        lbl.sizeToFit()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    lazy var convertButton: LoadingButton = {
        let button = LoadingButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont().withSize(18)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.systemBlue
        button.setTitle("Convert", for: .normal)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubsviews()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    func addSubsviews() {
        [justLabel, convertButton]
            .forEach {
                addSubview($0)
        }
    }
    
    func makeUI() {        
        justLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
        }
        
        convertButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.equalTo(justLabel.snp.leading)
            make.trailing.equalTo(justLabel.snp.trailing)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(60)
        }
        
        
        if (Display.typeIsLike == DisplayType.iphone5) {
            justLabel.font = justLabel.font.withSize(70)
        }
    }
}
