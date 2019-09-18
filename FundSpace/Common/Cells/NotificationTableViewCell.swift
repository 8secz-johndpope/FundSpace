//
//  NotificationTableViewCell.swift
//  FundSpace
//
//  Created by admin on 9/17/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageContainerView.layer.cornerRadius = imageContainerView.frame.width / 2.0
        imageContainerView.layer.borderWidth = 0.63
        imageContainerView.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2.0
        
        activeView.layer.cornerRadius = activeView.frame.width / 2.0
        activeView.layer.borderWidth = 2
        activeView.layer.borderColor = UIColor.white.cgColor
        activeView.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
