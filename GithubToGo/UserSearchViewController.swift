//
//  UserSearchViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/22/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var collectionView: UICollectionView!

    var users: [User]?
    var passImage: UIImage?
    
    // Save starting location of animation
    var origin: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
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
        
        self.title = searchText
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
        
        NetworkController.controller.downloadUserImageForUser(user!,completionHandler: { (image) -> (Void) in
            user?.downloadedImage = image
            cell.avatarImage.image = image
        })
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
