//
//  RepoCell.swift
//  GithubToGo
//
//  Created by Randall Leung on 10/20/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    
    @IBOutlet var repoNameLabel: UILabel!
    
    @IBOutlet var repoDescLabel: UILabel!
    
    @IBOutlet var userLabel: UILabel!
    
    @IBOutlet var languageLabel: UILabel!
    
    @IBOutlet var createdAtLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }




}
