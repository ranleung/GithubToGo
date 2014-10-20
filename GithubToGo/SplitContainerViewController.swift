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
        
        let splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate = self
        
        self.userDefaults = NSUserDefaults.standardUserDefaults()
        self.firstTimeLogginIn = self.userDefaults!.objectForKey("firstTimeLogin") as? Bool
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        
        if (self.firstTimeLogginIn == nil) {
            self.userDefaults?.setBool(true, forKey: "firstTimeLogin")
            return true
        } else {
            return false
        }

    }
    
    
    


}
