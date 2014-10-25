//
//  NetworkController.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit


class NetworkController {
    
    let imageQueue = NSOperationQueue()
    var mySession: NSURLSession?
    var accessToken: String?
    
    let clientID = "client_id=e251b331bff2250fe6a4"
    let clientSecret = "client_secret=27e443ad568e2e8de1e10b499c0fc106301e3878"
    let githubOAuthUrl = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=somefancyname://test"
    let githubPOSTURL = "https://github.com/login/oauth/access_token"
    
    init() {
        if self.mySession == nil {
            if let tokenValue = NSUserDefaults.standardUserDefaults().valueForKey("MyKey") as? String {
                self.accessToken = tokenValue
                var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                var HTTPAdditionalHeaders =  ["Authorization" : "token \(self.accessToken!)"]
                sessionConfiguration.HTTPAdditionalHeaders = HTTPAdditionalHeaders
                self.mySession = NSURLSession(configuration: sessionConfiguration)
            }
        }
    }
    
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
                        var accessTokenComponent = tokenResponse?.componentsSeparatedByString("access_token=")
                        let accessTokenComponentBack: AnyObject = accessTokenComponent![1]
                        accessTokenComponent = accessTokenComponentBack.componentsSeparatedByString("&scope")
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
 
    
    func fetchUserWithSearchTerm(user: String?, completionHandler: (errorDescription: String?, response: [User]?)-> (Void)) {
        
        let formattedSearchTerm = user?.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let url = NSURL(string: "https://api.github.com/search/users?q=\(formattedSearchTerm!)")
        
        let dataTask: Void = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    for header in httpResponse.allHeaderFields {
                        println(header)
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    let users = User.parseJSONDataIntoUsers(data)
                    println("Number of Users: \(users!.count)")
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(errorDescription: nil, response: users)
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
            
        }).resume()
    }
    
    func fetchUser(user: User, completionHandler: (errorDescription: String?, response: User?)-> (Void)) {
        
        let url = NSURL(string: "https://api.github.com/search/users/\(user)")
        let dataTask: Void = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    for header in httpResponse.allHeaderFields {
                        println(header)
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    //Fix this
                    let userInfo = User.parseJSONDataIntoUser(data, user: user)
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler(errorDescription: nil, response: userInfo)
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
            
        }).resume()
        
        
    }
    
    func fetchAuthenticatedUser(completionHandler: (errorDescription: String?, response: User?)-> (Void)) {
        let url = NSURL(string: "https://api.github.com/user")
        
        if self.mySession != nil {
            let dataTask: Void = self.mySession!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        for header in httpResponse.allHeaderFields {
                            println(header)
                        }
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        
                        //Fix this
                        let userInfo = User.parseJSONDataIntoAuthenticatedUser(data)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, response: userInfo)
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
                
            }).resume()
        }
    }
    
    func fetchAuthenticatedUserRepo(completionHandler: (errorDescription: String?, response: [Repo]?)-> (Void)) {
        let url = NSURL(string: "https://api.github.com/user/repos")
        
        if self.mySession != nil {
            let dataTask: Void = self.mySession!.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        for header in httpResponse.allHeaderFields {
                            println(header)
                        }
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        
                        
                        let repoInfo = Repo.parseJSONDataIntoAuthenticatedRepo(data)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, response: repoInfo)
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
                
            }).resume()
        }
    }
    
    func postRepo(repoDictionary: NSDictionary, completionHandler: (errorDescription: String?) -> (Void)) {
        var error: NSError?
        
        let url = NSURL(string: "https://api.github.com/user/repos")
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        let accessToken = NSUserDefaults.standardUserDefaults().valueForKey("MyKey") as String
        
        request.setValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPMethod = "POST"
        let JSONRequest = NSJSONSerialization.dataWithJSONObject(repoDictionary, options: nil, error: &error)
        request.HTTPBody = JSONRequest
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            var errorDescription : String?
            if error != nil {
                errorDescription = "Server request not sent. Something is wrong."
            } else {
                let httpResponse = response as NSHTTPURLResponse
                switch httpResponse.statusCode {
                case 200...299:
                    println("200 Status")
                case 400...499:
                    errorDescription = "This is the client's fault"
                case 500...599:
                    errorDescription = "This is the server's fault"
                default:
                    errorDescription = "Bad Response? \(httpResponse.statusCode)"
                }
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(errorDescription: errorDescription)
            })
            
        })
        dataTask.resume()
    }
    
    func downloadUserImageForUser(user: User, completionHandler: (image: UIImage)->(Void)) {
        self.imageQueue.addOperationWithBlock { () -> Void in
            
            let urlData = NSURL(string: user.avatarUrl!)
            //Now making the network call
            let imageData = NSData(contentsOfURL: urlData!)
            var avatarImage = UIImage(data: imageData!)
            
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
              completionHandler(image: avatarImage!)
            }
            
        }
    }
    
    
    
    

}