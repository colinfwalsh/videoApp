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


class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webView.allowsInlineMediaPlayback = true
        
        
        /*
        guard let url = URL(string: "http://vodlocker.to/embed?t=transformers") else {
        return}
        */
 
        //let urlString = "http://vodlocker.to/embed?t=transformers"
        
        //let urlString = "https://docs.google.com/file/d/0B9cglZyALNsYZUFOU09RUUlNOFk/preview"
        
        let title = "brokeback_mountain"
        
        let urlString = "http://vodlocker.to/embed?t=\(title)&referrer=link&server=alternate"
        
        guard let url = URL(string: urlString) else {
            return}
        
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 1.0)
        self.webView.loadRequest(urlRequest)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

