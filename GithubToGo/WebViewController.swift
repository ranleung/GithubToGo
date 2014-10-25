//
//  WebViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/23/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()
    var repo: Repo?
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "\(repo!.link!)")!))
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
}





