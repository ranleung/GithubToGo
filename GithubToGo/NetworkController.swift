//
//  NetworkController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit


class NetworkController {
    
    var mySession: NSURLSession?
    var accessToken: String?
    
    let clientID = "client_id=e251b331bff2250fe6a4"
    let clientSecret = "client_secret=27e443ad568e2e8de1e10b499c0fc106301e3878"
    let githubOAuthUrl = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=somefancyname://test"
    let githubPOSTURL = "https://github.com/login/oauth/access_token"
    
    //Creating a singleton class
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
    
    //Take the user of our app and send the to github
    func requestOAuthAccess() {
        let url = githubOAuthUrl + clientID + "&" + redirectURL + "&" + scope
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func handleOAuthURL(callbackURL: NSURL) {
        //Set up the request, parsing throught the url that given to us by Github
        let query = callbackURL.query
        println("The query is: \(query)")
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last
        //println("The Code is: \(code!)")
        //constructing the query string for the final POST call
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        var request = NSMutableURLRequest(URL: NSURL(string: githubPOSTURL)!)
        request.HTTPMethod = "POST"
        //Return NSData object from string
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        //Creates an HTTP request for the specified URL request object, and calls a handler upon completion.
        let dataTask: Void = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                println("Hello this is an error")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        //println("The token response is: \(tokenResponse!)")
                        var accessTokenComponent = tokenResponse?.componentsSeparatedByString("access_token=")
                        //println(accessTokenComponent)
                        let accessTokenComponentBack: AnyObject = accessTokenComponent![1]
                        //println(accessTokenComponentBack)
                        accessTokenComponent = accessTokenComponentBack.componentsSeparatedByString("&scope")
                        //println(accessTokenComponent!.first)
                        self.accessToken = accessTokenComponent?.first as? NSString
                        println("The accessToken is: \(self.accessToken!)")
                        
                        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                        configuration.HTTPAdditionalHeaders = ["Authorization": "token accessToken"]
                        self.mySession = NSURLSession(configuration: configuration)
                        
                        NSUserDefaults.standardUserDefaults().setObject("\(self.accessToken!)", forKey: "MyKey")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                    default:
                        println("Default case on status code")
                    }
                }
            }
        }).resume()
    }
    
    func fetchRepoWithSearchTerm(repoName: String?, completionHandler: (errorDescription: String?, response: [Repo]?)-> (Void)) {
        
        //If repoName contains a space
        let formattedSearchTerm = repoName?.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let url = NSURL(string: "https://api.github.com/search/repositories?q=\(formattedSearchTerm!)")


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