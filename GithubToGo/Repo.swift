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
    
    init(repoInfo: NSDictionary) {
        println(repoInfo)
        var itemsInfo = repoInfo["items"] as NSArray
        self.repoName = itemsInfo[0]["name"] as? String
        self.repoDesc = itemsInfo[0]["description"] as? String
    }
    
    class func parseJSONDataIntoRepos(rawJSONData: NSData) -> [Repo]? {
        var error: NSError?
        if let searchJSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: nil) as? NSDictionary {
            var repos = [Repo]()
            
            if let repoArray = searchJSONDictionary["items"] as? NSArray {
                for dictionary in repoArray {
                    if let repoDictionary = dictionary as? NSDictionary {
                        var newRepo = Repo(repoInfo: searchJSONDictionary)
                        repos.append(newRepo)
                    }
                }
            }
            return repos
        }
        return nil
    }
    
    
    
}

