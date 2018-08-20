//
//  Animation.swift
//  CircularLoader
//
//  Created by OlehMalichenko on 14.08.2018.
//  Copyright © 2018 OlehMalichenko. All rights reserved.
//

import Foundation
import UIKit

class AnimationCircle {
    
    static func forFirstResponder(with elements: Elements, view: UIView) {
        // animating for keyboard and input data
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            elements.shapeLayer.strokeColor = UIColor.clear.cgColor
            elements.trackLayer.strokeColor = UIColor.clear.cgColor
            elements.textfield.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            elements.textfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            elements.textfield.text = ""
            elements.percentegeLabel.textColor = UIColor.clear
            elements.imageView.alpha = 0
            elements.textfield.transform = elements.textfield.transform.translatedBy(x: 0, y: -view.center.y)
        })
        print("Animating For First Responder")
    }
    
    static func forResignFirstResponder(with elements: Elements) {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            elements.textfield.text = ""
            elements.textfield.transform = .identity
            elements.imageView.alpha = elements.imageView.image != nil ? 1 : 0
        }) { (_) in
            UIView.animate(withDuration: 0.4,  animations: {
                elements.textfield.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                elements.textfield.text = "Push here for input data"
                elements.textfield.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                elements.shapeLayer.strokeColor = UIColor.red.cgColor
                elements.percentegeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                elements.trackLayer.strokeColor = UIColor.gray.cgColor
            })
        }
        print("Animating For Resign First Responder")
    }
    
    static func forDownloadingFile(with elements: Elements) {
        elements.imageView.alpha = 0
        elements.shapeLayer.strokeEnd = 0
        elements.percentegeLabel.text = "0%"
        print("Animating for Downloading File")
    }
    
    static func forGottenImage(with elements: Elements, image: UIImage) {
        elements.imageView.alpha = 0
        elements.imageView.image = image
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
            elements.imageView.alpha = 1
        })
    }
    
    static func forCantGetImage(with elements: Elements) {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            elements.percentegeLabel.text = "0%"
            elements.textfield.text = ""
            elements.textfield.transform = .identity
            elements.imageView.alpha = elements.imageView.image != nil ? 0.3 : 0
        }) { (_) in
            UIView.animate(withDuration: 0.4,  animations: {
                elements.textfield.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                elements.textfield.text = "Push here for input data"
                elements.textfield.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                elements.shapeLayer.strokeColor = UIColor.red.cgColor
                elements.percentegeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                elements.trackLayer.strokeColor = UIColor.gray.cgColor
            })
        }
    }
}








