//
//  CreditPositionTableViewCell.swift
//  FundSpace
//
//  Created by admin on 9/6/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class CreditPositionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "creditPositionCell"
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerDescriptionLabel: UILabel!
    @IBOutlet weak var headerButtonImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
