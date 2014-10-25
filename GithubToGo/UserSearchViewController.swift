//
//  UserSearchViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/22/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!

    @IBOutlet var searchBar: UISearchBar!
    
    var users: [User]?
    var passImage: UIImage?
    
    // Save starting location of animation
    var origin: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find the nav controller in the view controller stack
        // and set ourselves as the delegate
        self.navigationController?.delegate = self
        
        self.searchBar.placeholder = "Search Users"
        self.title = "Users"
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.delegate = nil
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
        
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        var warningRect = CGRect(x: 37, y: 114, width: 300, height: 40)
        var warningLabel = UILabel()
        warningLabel.frame = warningRect
        warningLabel.backgroundColor = UIColor.redColor()
        warningLabel.textColor = UIColor.whiteColor()
        warningLabel.textAlignment = NSTextAlignment.Center
        warningLabel.layer.cornerRadius = 8
        warningLabel.clipsToBounds = true
        warningLabel.alpha = 0
        warningLabel.text = "Search does not support character '\(text)'"
        
        if text.validate() == false {
            view.addSubview(warningLabel)
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: { () -> Void in
                warningLabel.alpha = 1.0
                }, completion: { (finished) -> Void in
                    UIView.animateWithDuration(1.0, delay: 0.1, options: nil, animations: { () -> Void in
                        warningLabel.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            
                    })
            })
        }
        return text.validate()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let searchText = searchBar.text
        println("User is searching for: \(searchText)")
        NetworkController.controller.fetchUserWithSearchTerm(searchText, completionHandler: { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.users = response
                self.collectionView.reloadData()
            }
        })
        searchBar.resignFirstResponder()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.users != nil {
            return self.users!.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        
        let user = self.users?[indexPath.row]
        
        cell.loginLabel.text = user?.login
        
        //To make sure the cell image doesn't load twice
        cell.avatarImage.image = nil
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        if cell.tag == currentTag {
            NetworkController.controller.downloadUserImageForUser(user!,completionHandler: { (image) -> (Void) in
                user?.downloadedImage = image
                cell.avatarImage.image = image
                cell.avatarImage.layer.cornerRadius = 10
                cell.avatarImage.layer.masksToBounds = true
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Grab the attributes of the tapped upon cell(Layout information)
        let attributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        
        // Grab the onscreen rectangle of the tapped upon cell, relative to the collection view
        let origin = self.view.convertRect(attributes!.frame, fromCoordinateSpace: collectionView)
        
        // Save our starting location as the tapped upon cells frame
        self.origin = origin
        
        // Find tapped image, initialize next view controller
        let user = self.users?[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("UserDetailViewController") as UserDetailViewController
        
        viewController.user = user
        viewController.image = user?.downloadedImage
        viewController.reverseOrigin = self.origin!
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
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
        } else if let mainViewController = fromVC as? UserDetailViewController {
            if let userSearchView = toVC as? UserSearchViewController {
                let animator = HideImageAnimator()
                animator.origin = mainViewController.reverseOrigin
                
                return animator
            }
        }
        
        // All other types use default transition
        self.navigationController?.delegate = nil
        return nil
    }
    
    
    
 
 
    
    

}
