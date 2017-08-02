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
        
//        self.webView.allowsInlineMediaPlayback = true
        
        
        /*
        guard let url = URL(string: "http://vodlocker.to/embed?t=transformers") else {
        return}
        */
 
        //let urlString = "http://vodlocker.to/embed?t=transformers"
        
        //let urlString = "https://docs.google.com/file/d/0B9cglZyALNsYZUFOU09RUUlNOFk/preview"
        
        let title = "brokeback_mountain"
        
        let urlString = "http://vodlocker.to/embed?t=\(title)&referrer=link&server=alternate"
        
        //print(urlString.extractURLs())
        
        guard let url = URL(string: urlString) else {
            return}
        
        
        let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 1.0)
        self.webView.loadRequest(urlRequest)
        
        self.getDataFromVodLocker(url: urlString)
        
        /*
        let types: NSTextCheckingResult.CheckingType = .link
        
        let detector = try? NSDataDetector(types: types.rawValue)
        
        guard let detect = detector else {
            return
        }
        
        let matches = detect.matches(in: urlString, options: .reportCompletion, range: NSMakeRange(0, urlString.characters.count))
        
        for match in matches {
            print(match.url!)
        }
         */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromVodLocker(url: String) -> Void {
        Alamofire.request(url).responseString {response in
            //print("\(response.result.value)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            //print(doc.at_xpath("<script>"))
        }
    }

    
}

extension String {
    func extractURLs() -> [NSURL] {
        var urls : [NSURL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self,
                                      options: [],
                                      range: NSMakeRange(0, self.characters.count),
                                      using: { (result, _, _) in
                                                if let match = result, let url = match.url {
                                                    urls.append(url as NSURL)
                                                }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}

