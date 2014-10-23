//
//  User.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/22/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class User {
    
    var login: String?
    var avatarUrl: String?
    var downloadedImage: UIImage?
    
    init(userInfo: NSDictionary) {
        self.login = userInfo["login"] as? String
        self.avatarUrl = userInfo["avatar_url"] as? String
    }
    
    class func parseJSONDataIntoUsers(rawJSONData: NSData) -> [User]? {
        var error: NSError?
        if let searchJSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: nil) as? NSDictionary {
            var users = [User]()
            
            if let userArray = searchJSONDictionary["items"] as? NSArray {
                for dictionary in userArray {
                    if let userDictionary = dictionary as? NSDictionary {
                    var newUser = User(userInfo: userDictionary)
                    users.append(newUser)
                    }
                }
            }
            return users
        }
        return nil
    }

    
    
    
}



