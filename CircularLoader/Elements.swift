//
//  Elements.swift
//  CircularLoader
//
//  Created by OlehMalichenko on 13.08.2018.
//  Copyright © 2018 OlehMalichenko. All rights reserved.
//

import UIKit

class Elements {
    
    // Used elements
    let shapeLayer = CAShapeLayer()
    
    let trackLayer = CAShapeLayer()
    
    let percentegeLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    let  imageView = UIImageView()
    let textfield: UITextField = {
        let textfield = UITextField()
        textfield.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textfield.text = "Push here for input data"
        textfield.textAlignment = .center
        textfield.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return textfield
    }()
    
    // drawing elements
    func drawTrackAndShapeLayer(in view: UIView) {
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: 100,
                                        startAngle: 0,
                                        endAngle: CGFloat.pi * 2,
                                        clockwise: true)
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = kCALineCapRound
        trackLayer.strokeEnd = 1
        trackLayer.path = circularPath.cgPath
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        shapeLayer.path = circularPath.cgPath
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
    }
    
    func drawPercentegeLabel (in view: UIView) {
        percentegeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentegeLabel.center = view.center
        view.addSubview(percentegeLabel)
    }
    
    func drawImageView(in view: UIView) {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        
    }
    
    func drawTextField(in view: UIView) {
        view.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        textfield.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        textfield.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.layer.cornerRadius = 3
    }
}









