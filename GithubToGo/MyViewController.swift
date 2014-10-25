//
//  MyViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/24/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {

    var user: User!
    
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var followerLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!
    @IBOutlet var hireableLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkController.controller.fetchAuthenticatedUser { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.user = response!
                self.urlLabel.text = self.user.url!
                self.nameLabel.text = self.user.name!
                self.loginLabel.text = self.user.login!
                self.emailLabel.text = self.user.email!
                self.followerLabel.text = String(self.user.followers!)
                self.followingLabel.text = String(self.user.following!)
                self.hireableLabel.text = "\(self.user.hireable!)"
                
                NetworkController.controller.downloadUserImageForUser(self.user, completionHandler: { (image) -> (Void) in
                    self.imageView.image = image
                })
            }
        }
        
        NetworkController.controller.fetchAuthenticatedUserRepo { (errorDescription, response) -> (Void) in
            println(errorDescription)
            println(response)
        }
        
       
        
        
    }
    
    
    
    
    
    
    
}
