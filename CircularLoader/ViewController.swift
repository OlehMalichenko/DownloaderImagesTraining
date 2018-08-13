//
//  ViewController.swift
//  CircularLoader
//
//  Created by OlehMalichenko on 04.08.2018.
//  Copyright © 2018 OlehMalichenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    var elements = Elements()
    
    // setup drawing elements and tap gesture
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        elements.drawTrackAndShapeLayer(in: self.view)
        elements.drawPercentegeLabel(in: self.view)
        elements.drawImageView(in: self.view)
        elements.drawTextField(in: self.view)
        elements.textfield.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlTap)))
    }
    
    // calling to downloader
    @objc fileprivate func handlTap() {
        print("tap gesture")
        actionAfterInputData()
    }
    
    // create URLSession and get task
    fileprivate func beginDownloadingFile(from urlString: String) {
        print("begin downloading file")
        elements.imageView.alpha = 0
        elements.shapeLayer.strokeEnd = 0
        elements.percentegeLabel.text = "0%"
        let confiruration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: confiruration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: urlString) else {
            let massege = "Can`t get URL from String \n Try agan?"
            print(massege)
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
            self.elements.shapeLayer.strokeEnd = percentage
            self.elements.percentegeLabel.text = "\(newPercentage)%"
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
                self.elements.imageView.alpha = 0
                self.elements.imageView.image = image
                UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: {
                    self.elements.imageView.alpha = 1
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
        actionAfterInputData()
        return true
    }
    
    fileprivate func actionAfterInputData() {
        let textfield = elements.textfield
        if textfield.text == "" {
            animatingForResignFirstResponder()
            textfield.resignFirstResponder()
            print("Animating For Resign First Responder")
        } else if textfield.text != "" && textfield.text != nil {
            let text = textfield.text!
            animatingForResignFirstResponder()
            textfield.resignFirstResponder()
            beginDownloadingFile(from: text)
            print("Animating For Resign First Responder and called to downloading file")
        }
    }
    
    fileprivate func animatingForFirstResponder() {
        // animating for keyboard and input data
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.elements.shapeLayer.strokeColor = UIColor.clear.cgColor
            self.elements.trackLayer.strokeColor = UIColor.clear.cgColor
            self.elements.textfield.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.elements.textfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.elements.textfield.text = ""
            self.elements.percentegeLabel.textColor = UIColor.clear
            self.elements.imageView.alpha = 0
            self.elements.textfield.transform = self.elements.textfield.transform.translatedBy(x: 0, y: -self.view.center.y)
        })
    }
    
    fileprivate func animatingForResignFirstResponder() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.elements.textfield.text = ""
            self.elements.textfield.transform = .identity
            self.elements.imageView.alpha = self.elements.imageView.image != nil ? 1 : 0
        }) { (_) in
            UIView.animate(withDuration: 0.4,  animations: {
                self.elements.textfield.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.elements.textfield.text = "Push here for input data"
                self.elements.textfield.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.elements.shapeLayer.strokeColor = UIColor.red.cgColor
                self.elements.percentegeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.elements.trackLayer.strokeColor = UIColor.gray.cgColor
            })
        }
    }
}







