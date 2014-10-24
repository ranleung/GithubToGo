//
//  RootViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/22/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find the nav controller in the view controller stack
        // and set ourselves as the delegate
        self.navigationController?.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.delegate = nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // This is called whenever during all navigation operations
        
        // Only return a custom animator for two view controller types
        if let mainViewController = fromVC as? UserSearchViewController {
            if let userDetailView = toVC as? UserDetailViewController {
                let animator = ShowImageAnimator()
                animator.origin = mainViewController.origin
                
                return animator
            }
        }
        else if let mainViewController = fromVC as? UserDetailViewController {
            if let userSearchView = toVC as? UserSearchViewController {
                let animator = HideImageAnimator()
                animator.origin = mainViewController.reverseOrigin
                
                return animator
            }
        }
        
        // All other types use default transition
        return nil
    }
    




}
