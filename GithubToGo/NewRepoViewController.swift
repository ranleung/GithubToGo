//
//  NewRepoViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/24/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class NewRepoViewController: UIViewController {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var descField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func submitButton(sender: AnyObject) {
        
        var newPostDictionary = [String: String]()
        
        newPostDictionary["name"] = titleField.text
        newPostDictionary["description"] = descField.text
        
        NetworkController.controller.postRepo(newPostDictionary) { (errorDescription) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                println("WORKED!")
            }
        }
        
        //Now to redirect back to Auth Repo page
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("MyViewController") as MyViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    


}
