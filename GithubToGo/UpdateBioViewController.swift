//
//  UpdateBioViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/25/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class UpdateBioViewController: UIViewController {

    @IBOutlet var bioField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func updateBioButton(sender: AnyObject) {
        var newPatchDictionary = [String: String]()
        
        newPatchDictionary["bio"] = self.bioField.text

        NetworkController.controller.updateBio(newPatchDictionary) { (errorDescription) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                println("WORKED!")
            }
        }
        
    }





}
