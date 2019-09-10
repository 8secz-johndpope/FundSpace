//
//  LeaderProjectTableViewCell.swift
//  FundSpace
//
//  Created by admin on 9/9/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class LeaderProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectCostLabel: UILabel!
    @IBOutlet weak var projectPermissionLabel: UILabel!
    @IBOutlet weak var projectTypeView: UIView!
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectAddressLabel: UILabel!
    @IBOutlet weak var projectBedroomsView: UIView!
    @IBOutlet weak var projectBedroomsLabel: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        projectTypeView.clipsToBounds = true
        projectTypeView.layer.cornerRadius = 10
        projectTypeView.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
