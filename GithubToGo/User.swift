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
    
    //For Authenticated user
    var email: String?
    var followers: Int?
    var following: Int?
    var userLogin: String?
    var userName: String?
    var privateRepo: Int?
    var publicRpo: Int?
    var url: String?
    var hireable: Bool?
    var name: String?
    var bio: String?

    
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
    
    class func parseJSONDataIntoUser(rawJSONData: NSData, user: User) -> User? {
        var error: NSError?
        
        if let searchJSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: nil) as? NSDictionary {
 
            
            if let userArray = searchJSONDictionary["items"] as? NSArray {
                for dictionary in userArray {
                    if let userDictionary = dictionary as? NSDictionary {
                        println(userDictionary)
                        user.login = userDictionary["login"] as? String
                        user.email = userDictionary["email"] as? String
                        
                    }
                }
            }
        }
        return user
    }
    
    class func parseJSONDataIntoAuthenticatedUser (rawJSONData: NSData) -> User? {
        var error: NSError?
        
        if let JSON = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: nil) as? NSDictionary {
            
            var user = User(userInfo: JSON)
            
            user.email = JSON["email"] as? String
            user.followers = JSON["followers"] as? Int
            user.following = JSON["following"] as? Int
            user.userLogin = JSON["login"] as? String
            user.userName = JSON["name"] as? String
            user.publicRpo = JSON["public_repos"] as? Int
            user.url = JSON["url"] as? String
            user.hireable = JSON["hireable"] as? Bool
            user.name = JSON["name"] as? String
            user.bio = JSON["bio"] as? String
            
            let plan = JSON["plan"] as NSDictionary
            user.privateRepo = plan["private_repos"] as? Int
            
            return user
        }
        return nil
    }
    
    
    
}












