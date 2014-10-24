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
        
        
//        var actInd = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
//        actInd.center = self.view.center
//        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        self.webView.addSubview(actInd)
//        actInd.startAnimating()
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "\(repo!.link!)")!))
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
}





