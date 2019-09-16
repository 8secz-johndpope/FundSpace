//
//  ExpandedCreditPositionTableViewCell.swift
//  FundSpace
//
//  Created by admin on 9/6/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class ExpandedCreditPositionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailView: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainYesBtn: UIButton!
    @IBOutlet weak var mainNoBtn: UIButton!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var secondYesBtn: UIButton!
    @IBOutlet weak var secondNoBtn: UIButton!
    
    var main_selected: Bool = false
    var second_selected: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI() {
        mainYesBtn.layer.cornerRadius = 6
        mainYesBtn.layer.borderWidth = 1
        mainYesBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        mainYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        
        mainNoBtn.layer.cornerRadius = 6
        mainNoBtn.layer.borderWidth = 1
        mainNoBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        mainNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        
        secondYesBtn.layer.cornerRadius = 6
        secondYesBtn.layer.borderWidth = 1
        secondYesBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        secondYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        
        secondNoBtn.layer.cornerRadius = 6
        secondNoBtn.layer.borderWidth = 1
        secondNoBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        secondNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
    }
    
    @IBAction func mainYesBtn_Click(_ sender: Any) {
        mainYesBtn.setTitleColor(.white, for: .normal)
        mainYesBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        mainNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        mainNoBtn.backgroundColor = .clear
        
        main_selected = true
    }
    
    @IBAction func mainNoBtn_Click(_ sender: Any) {
        mainNoBtn.setTitleColor(.white, for: .normal)
        mainNoBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        mainYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        mainYesBtn.backgroundColor = .clear
        
        main_selected = false
    }
    
    
    @IBAction func secondYesBtn_Click(_ sender: Any) {
        secondYesBtn.setTitleColor(.white, for: .normal)
        secondYesBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        secondNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        secondNoBtn.backgroundColor = .clear
        
        second_selected = true
    }
    
    @IBAction func secondNoBtn_Click(_ sender: Any) {
        secondNoBtn.setTitleColor(.white, for: .normal)
        secondNoBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        secondYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        secondYesBtn.backgroundColor = .clear
        
        second_selected = false
    }

}
