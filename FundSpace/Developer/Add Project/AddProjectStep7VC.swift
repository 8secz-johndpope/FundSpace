//
//  AddProjectStep7VC.swift
//  FundSpace
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddProjectStep7VC: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var sellCheckBox: Checkbox!
    @IBOutlet weak var sellLabel: UILabel!
    
    @IBOutlet weak var refinanceCheckBox: Checkbox!
    @IBOutlet weak var refinanceLabel: UILabel!
    
    @IBOutlet weak var captialCostTextField: SkyFloatingLabelTextField!
    
    let selectColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
    let unSelectColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    let unSelectTextColor = UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        stackView.addBottomBorder(color: unSelectColor, margins: 0, borderLineSize: 1)
        
        sellCheckBox.checkedBorderColor = selectColor
        sellCheckBox.uncheckedBorderColor = unSelectColor
        sellCheckBox.borderStyle = .circle
        sellCheckBox.checkmarkColor = selectColor
        sellCheckBox.checkmarkStyle = .circle
        
        refinanceCheckBox.checkedBorderColor = selectColor
        refinanceCheckBox.uncheckedBorderColor = unSelectColor
        refinanceCheckBox.borderStyle = .circle
        refinanceCheckBox.checkmarkColor = selectColor
        refinanceCheckBox.checkmarkStyle = .circle
        
        sellCheckBox.isChecked = true
        sellLabel.textColor = selectColor
        
        refinanceCheckBox.isChecked = false
        refinanceLabel.textColor = unSelectTextColor
        
        captialCostTextField.font = UIFont(name: "OpenSans", size: 15)
        
        sellCheckBox.valueChanged = { (value) in
            self.sellCheckBox.isChecked = true
            self.sellLabel.textColor = self.selectColor
            
            self.refinanceCheckBox.isChecked = false
            self.refinanceLabel.textColor = self.unSelectTextColor
            
        }
        
        refinanceCheckBox.valueChanged = { (value) in
            self.sellCheckBox.isChecked = false
            self.sellLabel.textColor = self.unSelectTextColor
            
            self.refinanceCheckBox.isChecked = true
            self.refinanceLabel.textColor = self.selectColor
        }
    }
}
