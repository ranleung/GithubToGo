//
//  StringExtension.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/23/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation

extension String {
    
    func validate() -> Bool{
        let regrex = NSRegularExpression(pattern: "[^0-9a-zA-Z]", options: nil, error: nil)
        let match = regrex?.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self)))
        if match > 0 {
            return false
        } else {
            return true
        }
    }
    
    
}

