//
//  Repo.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class Repo {
    
    var repoName: String?
    var repoDesc: String?
    var language: String?
    var createdAt: String?
    var login: String?
    var link: String?
    
    init(repoInfo: NSDictionary) {
        println(repoInfo)
        self.repoName = repoInfo["name"] as? String
        self.repoDesc = repoInfo["description"] as? String
        self.language = repoInfo["language"]  as? String
        let unformatedCreatedAt = repoInfo["created_at"] as? String
        var createdAtComponent = unformatedCreatedAt?.componentsSeparatedByString("T")
        self.createdAt = createdAtComponent?.first
        let owner = repoInfo["owner"] as NSDictionary
        self.login = owner["login"] as? String
        self.link = repoInfo["html_url"] as? String
    }
    
    class func parseJSONDataIntoRepos(rawJSONData: NSData) -> [Repo]? {
        var error: NSError?
        if let searchJSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: nil) as? NSDictionary {
            var repos = [Repo]()
            
            if let repoArray = searchJSONDictionary["items"] as? NSArray {
                for dictionary in repoArray {
                    if let repoDictionary = dictionary as? NSDictionary {
                        var newRepo = Repo(repoInfo: repoDictionary)
                        repos.append(newRepo)
                    }
                }
            }
            return repos
        }
        return nil
    }
    
    class func parseJSONDataIntoAuthenticatedRepo (rawJSONData: NSData) -> [Repo]? {
        var error: NSError?
        
        if let searchJSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: nil) as? NSArray {
            //println(searchJSONArray)
            var repos = [Repo]()
            
            for dictionary in searchJSONArray {
                if let repoDict = dictionary as? NSDictionary {
                    repos.append(Repo(repoInfo: repoDict))
                }
            }
            return repos
        }
        return nil
    }
    
    
    
    
}

