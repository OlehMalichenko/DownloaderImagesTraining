//
//  ViewController.swift
//  CircularLoader
//
//  Created by OlehMalichenko on 04.08.2018.
//  Copyright © 2018 OlehMalichenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        if elements.textfield.isFirstResponder {
            actionAfterInputData()
        }
    }
    
    // wen data in textField begin this action
    fileprivate func actionAfterInputData() {
        let textfield = elements.textfield
        if textfield.text == "" {
            AnimationCircle.forResignFirstResponder(with: elements)
            textfield.resignFirstResponder()
        } else if textfield.text != "" && textfield.text != nil {
            let text = textfield.text!
            AnimationCircle.forResignFirstResponder(with: elements)
            textfield.resignFirstResponder()
            guard let url = checkURL(from: text) else {
                return
            }
            beginDownloadingFile(from: url)
        }
    }
    
    // checking the text for get URL
    fileprivate func checkURL(from text: String) -> URL? {
        guard let url = URL(string: text) else {
            return nil
        }
        return url
    }
    
    // create URLSession and get task
    fileprivate func beginDownloadingFile(from url: URL) {
        print("begin downloading file")
        AnimationCircle.forDownloadingFile(with: elements)
        let confiruration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: confiruration, delegate: self, delegateQueue: operationQueue)
        let downloadTask =  urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
}


extension ViewController: URLSessionDownloadDelegate {
    // finished download and adding image to imageView
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading file")
        do {
            let data = try Data.init(contentsOf: location)
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                 AnimationCircle.forCantGetImage(with: self.elements)
                }
                print("can`t get image")
                return
            }
            DispatchQueue.main.async {
                AnimationCircle.forGottenImage(with: self.elements, image: image)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
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

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error != nil else {
            print("NOT errors")
            return}
        print("didCompleteWithError")
        DispatchQueue.main.async {
            AnimationCircle.forResignFirstResponder(with: self.elements)
        }
    }
}


extension ViewController: UITextFieldDelegate {
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        AnimationCircle.forFirstResponder(with: elements, view: self.view)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionAfterInputData()
        return true
    }
}







