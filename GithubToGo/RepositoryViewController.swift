//
//  RepositoryViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
import WebKit

class RepositoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBar: UISearchBar!
    var repos: [Repo]?
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Using Nib instead of segeue
        self.tableView.registerNib(UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "REPO_CELL")
        
        tableView.estimatedRowHeight = 148.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = "Repositories"
        
        self.searchBar.placeholder = "Search Repositories"

        //In storyboard, already set the searchBar delegate to View Controller
        //self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
        
        let repo = self.repos?[indexPath.row]
        
        cell.repoNameLabel.text = repo?.repoName
        cell.repoDescLabel.text = repo?.repoDesc
        cell.languageLabel.text = repo?.language
        cell.createdAtLabel.text = repo?.createdAt
        cell.userLabel.text = ("By: \(repo!.login!)")

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
        let indexPath = self.tableView.indexPathForSelectedRow()!
        let selectedRepo = self.repos?[indexPath.row]
        newVC.repo = selectedRepo
        self.navigationController?.pushViewController(newVC, animated: true)
    }

   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String)-> Bool {
        println(text)
        
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
        self.tableView.hidden = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.color = UIColor.redColor()
        let searchText = searchBar.text
        println("User is searching for: \(searchText)")
        NetworkController.controller.fetchRepoWithSearchTerm(searchText, completionHandler: { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.activityIndicator.stopAnimating()
                self.tableView.hidden = false
                self.repos = response
                self.tableView.reloadData()
            }
        })
        searchBar.resignFirstResponder()
        
        self.title = searchText
    }
    
    
    
    
    
    
    
    
    
}
