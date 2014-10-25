//
//  MyViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/24/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var user: User!
    var repos: [Repo]?
    
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
        
        //Using nib
        self.tableView.registerNib(UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "REPO_CELL")
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
                    self.imageView.layer.cornerRadius = 10
                    self.imageView.layer.masksToBounds = true
                })
            }
        }
        
        NetworkController.controller.fetchAuthenticatedUserRepo { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.repos = response
                self.tableView.reloadData()
            }
        }
       
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.repos != nil {
            return self.repos!.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as RepoCell
        
        let repo = self.repos![indexPath.row]
        cell.repoDescLabel.text = repo.repoDesc!
        cell.repoNameLabel.text = repo.repoName
        cell.createdAtLabel.text = repo.createdAt
        cell.languageLabel.text = repo.language
        cell.userLabel.text = repo.login
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
        let indexPath = self.tableView.indexPathForSelectedRow()!
        let selectedRepo = self.repos?[indexPath.row]
        newVC.repo = selectedRepo
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    
    
    
    
    
    
}
