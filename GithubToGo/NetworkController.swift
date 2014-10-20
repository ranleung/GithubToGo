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
    
    func fetchRepoWithSearchTerm(repoName: String?, completionHandler: (errorDescription: String?, response: String?)-> (Void)) {
        
        let url = NSURL(string: "http://localhost:3000/")
        //setup data task for resource at URL
        //make a GET request, by default
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    for header in httpResponse.allHeaderFields {
                        println(header)
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("responseString: \(responseString)")
                default:
                    println("Bad Response? \(httpResponse.statusCode)")
                }
            }
        })
        dataTask.resume()
    }
    
    
    

}