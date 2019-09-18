//
//  DeveloperInboxTableViewCell.swift
//  FundSpace
//
//  Created by admin on 9/16/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class InboxTableViewCell: MGSwipeTableCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var userInfo: [String: Any]!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView?.layer.cornerRadius = (imageView?.frame.width)! / 2.0
        imageView?.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        imageView?.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
