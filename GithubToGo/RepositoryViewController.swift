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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 148.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        NetworkController.controller.fetchRepoWithSearchTerm("Hello World", completionHandler: { (errorDescription, response) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.repos = response
                self.tableView.reloadData()
            }
        })
        
        //In storyboard, set searchBar delegate to View Controller
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
        
        return cell
        
    }
   
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println(searchText)
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
    }
    


}
