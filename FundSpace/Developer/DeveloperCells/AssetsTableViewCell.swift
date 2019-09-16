//
//  AssetsTableViewCell.swift
//  FundSpace
//
//  Created by admin on 9/16/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class AssetsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "assetsTableViewCell"
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
