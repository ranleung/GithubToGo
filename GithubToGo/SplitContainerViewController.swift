//
//  SplitContainerViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class SplitContainerViewController: UIViewController, UISplitViewControllerDelegate {
    
    var userDefaults: NSUserDefaults?
    var firstTimeLogginIn: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NetworkController.controller.accessToken == nil {
            dispatch_after(1, dispatch_get_main_queue(), {
                NetworkController.controller.requestOAuthAccess()
            })
        }
        
        let splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate = self
        
        self.userDefaults = NSUserDefaults.standardUserDefaults()
        self.firstTimeLogginIn = self.userDefaults!.objectForKey("firstTimeLogin") as? Bool
        
        
    }
    
    //Gets called when the view is collasped
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        if (self.firstTimeLogginIn != true) {
            //if NOT first time login, false is first time
            self.userDefaults?.setBool(true, forKey: "firstTimeLogin")
            return false
        } else {
            //if FIRST time login, true is second time
            return true
        }
    }
    




}
