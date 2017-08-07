//
//  ViewController.swift
//  vodLockerApp
//
//  Created by Colin Walsh on 7/26/17.
//  Copyright © 2017 Colin Walsh. All rights reserved.
//

import UIKit
import Kanna
import Alamofire
import Foundation


class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var movieTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webView.allowsInlineMediaPlayback = true

        let urlString = "http://vodlocker.to/embed?t=\(self.movieTitle.lowercased())&referrer=link&server=alternate"
        
        guard let url = URL(string: urlString) else {
            return}
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        Alamofire.request(urlRequest).response {response in
            if response.response == nil {
                print("Cannot load video for some reason...")
            } else {
                
                OperationQueue.main.addOperation {
                    if let request = response.request {
                        self.webView.loadRequest(request)
                    }
                }
            }
        }
        
    }
    
    func runPythonScript() {
        
        
        
        
      
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

