//
//  NetworkController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation
import Social


class NetworkController {
    
    class var controller : NetworkController {
    struct Static {
        static var onceToken : dispatch_once_t = 0
        static var instance : NetworkController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkController()
        }
        return Static.instance!
    }
    
    func fetchRepoWithSearchTerm(repoName: String?, completionHandler: (errorDescription: String?, response: [Repo]?)-> (Void)) {
        
        let url = NSURL(string: "http://localhost:3000/")
        //setup data task for resource at URL
        //make a GET request, by default
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    for header in httpResponse.allHeaderFields {
                        println(header)
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    //println("responseString: \(responseString)")
                    
                    let repos = Repo.parseJSONDataIntoRepos(data)
                    println("Number of REPOS: \(repos!.count)")
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(errorDescription: nil, response: repos)
                    })
                    
                case 400...499:
                    println("This is the clients fault")
                    println(httpResponse.description)
                    completionHandler(errorDescription: "This is the client's fault", response: nil)
                case 500...599:
                    println("This is the servers fault")
                    println(httpResponse.description)
                    completionHandler(errorDescription: "This is the servers's fault", response: nil)
                default:
                    println("Bad Response? \(httpResponse.statusCode)")
                }
            }
        })
        dataTask.resume()
    }
    
    
    

}