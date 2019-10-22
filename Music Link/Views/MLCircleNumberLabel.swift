//
//  MLCircleNumberLabel.swift
//  Music Link - Sharing Streams
//
//  Created by uuttff8 on 10/22/19.
//  Copyright © 2019 uuttff8. All rights reserved.
//

import UIKit

private final class MLCircle: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
            // Get the Graphics Context
        if let context = UIGraphicsGetCurrentContext() {
            
            // Set the circle outerline-width
            context.setLineWidth(5.0);
            
            // Set the circle outerline-colour
            UIColor.red.set()
            
            // Create Circle
            let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
            let radius = (frame.size.width - 10)/2
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
                
            // Draw
            context.strokePath()
        }
    }
}

class MLCircleNumberLabel: UIView {
    
    var index: Int!
    var text: String!
    
    private lazy var mlCircle: MLCircle = {
        let view = MLCircle()
        return view
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = UILabel()
        label.text = String(self.index)
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 30)
        label.sizeToFit()
        
        label.center = self.mlCircle.center
        
        return label
    }()
    
    private lazy var labelText: UILabel = {
        let label = UILabel()
        label.text = self.text
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    init(index: Int, text: String, width: Int) {
        if index > 9 {
            fatalError("only in range [1;9]")
        }
        
        self.index = index
        self.text = text
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 60))
        
        self.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        addSubview(mlCircle)
        addSubview(labelNumber)
        addSubview(labelText)
        
        NSLayoutConstraint.activate([
            labelText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 20),
            labelText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            labelText.leadingAnchor.constraint(equalTo: self.mlCircle.trailingAnchor, constant: 20)
        ])
    }
}

