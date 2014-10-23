//
//  UserDetailViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/22/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var userLabel: UILabel!

    // Save final location of animation
    var reverseOrigin: CGRect?
    var image: UIImage?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail User Page"
        
        self.imageView.image = self.image
        self.userLabel.text = self.user?.login
    }
    

}
