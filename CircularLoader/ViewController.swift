//
//  ViewController.swift
//  CircularLoader
//
//  Created by OlehMalichenko on 04.08.2018.
//  Copyright © 2018 OlehMalichenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
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
    
    
    // setup drawing elements and tap gesture
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        drawingTrackAndShapeLayer()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlTap)))
    }
    
    
    // drawing elements
    fileprivate func drawingTrackAndShapeLayer() {
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
        trackLayer.position = self.view.center
        self.view.layer.addSublayer(trackLayer)
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        shapeLayer.path = circularPath.cgPath
        shapeLayer.position = self.view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        self.view.layer.addSublayer(shapeLayer)
        
        percentegeLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentegeLabel.center = self.view.center
        self.view.addSubview(percentegeLabel)
        
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        textfield.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        textfield.widthAnchor.constraint(equalToConstant: self.view.frame.width - 20).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textfield.layer.cornerRadius = 3
        textfield.delegate = self
    }
    
    // calling to downloader
    @objc fileprivate func handlTap() {
        print("tap gesture")
        if textfield.isFirstResponder && textfield.text == "" {
            animatingForResignFirstResponder()
            textfield.resignFirstResponder()
            print("Tap. Animating For Resign First Responder")
        } else if textfield.isFirstResponder && textfield.text != "" && textfield.text != nil {
            let text = textfield.text!
            animatingForResignFirstResponder()
            textfield.resignFirstResponder()
            beginDownloadingFile(from: text)
            print("Tap. Animating For Resign First Responder and called to downloading file")
        }
    }
    
    // create URLSession and get task
    fileprivate func beginDownloadingFile(from urlString: String) {
        print("begin downloading file")
        self.imageView.alpha = 0
        self.shapeLayer.strokeEnd = 0
        self.percentegeLabel.text = "0%"
        let confiruration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: confiruration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: urlString) else {
            print("Error: can`t get URL from String")
            return
        }
        let downloadTask =  urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // URLSessionDownloadDelegate
    // format bytes in percentage and extend strokeEnd to geting bytes
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        let newPercentage = Int(percentage * 100)
        // updeting strokeEnd from queue URLsession
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = percentage
            self.percentegeLabel.text = "\(newPercentage)%"
        }
        print(percentage)
    }
    
    // finished download and adding image to imageView
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
        do {
            let data = try Data.init(contentsOf: location)
            guard let image = UIImage(data: data) else {
                print("can`t get image")
                return
            }
            DispatchQueue.main.async {
                self.imageView.alpha = 0
                self.imageView.image = image
                UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
                    self.imageView.alpha = 1
                })
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}


extension ViewController: UITextFieldDelegate {
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animatingForFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textfield.text == "" {
            animatingForResignFirstResponder()
            textfield.resignFirstResponder()
            print("Return. Animating For Resign First Responder")
        } else if textfield.text != "" && textfield.text != nil {
            let text = textfield.text!
            animatingForResignFirstResponder()
            textfield.resignFirstResponder()
            beginDownloadingFile(from: text)
            print("Return. Animating For Resign First Responder and called to downloading file")
        }
        return true
    }
    
    fileprivate func animatingForFirstResponder() {
        self.shapeLayer.strokeColor = UIColor.clear.cgColor
        self.trackLayer.strokeColor = UIColor.clear.cgColor
        self.textfield.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.textfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // animating for keyboard and input data
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.textfield.text = ""
            self.percentegeLabel.textColor = UIColor.clear
            self.imageView.alpha = 0
            self.textfield.transform = self.textfield.transform.translatedBy(x: 0, y: -(self.view.center.y))
        })
    }
    
    fileprivate func animatingForResignFirstResponder() {
        self.shapeLayer.strokeColor = UIColor.red.cgColor
        self.trackLayer.strokeColor = UIColor.gray.cgColor
        self.textfield.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.textfield.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.textfield.text = ""
            self.textfield.transform = .identity
            self.imageView.alpha = self.imageView.image != nil ? 1 : 0
        }) { (_) in
            UIView.animate(withDuration: 0.4, animations: {
                self.percentegeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.textfield.text = "Push here for input data"
            })
        }
    }
}







