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
        // NOT YET WORKING
        if (self.firstTimeLogginIn != true) {
            //if NOT first time login
            self.userDefaults?.setBool(true, forKey: "firstTimeLogin")
            return false
        } else {
            //if FIRST time login
            return true
        }
    }
    
    //false is first time
    // true is second time
    //http://stackoverflow.com/questions/26415806/showing-action-sheet-when-iphone-app-launches-the-first-time-ios-8


}
