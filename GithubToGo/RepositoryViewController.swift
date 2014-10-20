//
//  RepositoryViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController {

    var networkController: NetworkController!

    var testRepoName: String = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.networkController.fetchRepoWithSearchTerm(nil, completionHandler: { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                println(response)
            }
        })
    }

    


}
