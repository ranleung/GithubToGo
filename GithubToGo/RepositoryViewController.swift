//
//  RepositoryViewController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    var repos: [Repo]?
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Using Nib instead of segeue
        self.tableView.registerNib(UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "REPO_CELL")
        
        tableView.estimatedRowHeight = 148.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let initalSearch = "Hello World"
        self.title = initalSearch
        
        NetworkController.controller.fetchRepoWithSearchTerm(initalSearch, completionHandler: { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.repos = response
                self.tableView.reloadData()
            }
        })
        
        
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
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String)-> Bool {
        println(text)
        if text.validate() == true {
            println("True")
            searchBar.barTintColor = nil
            return text.validate()
        } else {
            println("false")
            searchBar.barTintColor = UIColor.redColor()
            return text.validate()
        }
        
    }
    

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let searchText = searchBar.text
        println("User is searching for: \(searchText)")
        
        NetworkController.controller.fetchRepoWithSearchTerm(searchText, completionHandler: { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.repos = response
                self.tableView.reloadData()
            }
        })
        searchBar.resignFirstResponder()
        
        self.title = searchText
    }
    
    
    
    
    
    
    
    
    
}
