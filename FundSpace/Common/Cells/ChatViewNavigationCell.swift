//
//  ChatViewNavigationCell.swift
//  FundSpace
//
//  Created by admin on 9/14/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class ChatViewNavigationCell: UIView {
    @IBOutlet weak var profileImageContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        profileImageContainerView.layer.cornerRadius = profileImageContainerView.frame.width / 2.0
        profileImageContainerView.layer.borderWidth = 0.63
        profileImageContainerView.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        
        activeView.layer.cornerRadius = activeView.frame.width / 2.0
        activeView.layer.borderWidth = 2
        activeView.layer.borderColor = UIColor.white.cgColor
    }
    
}
