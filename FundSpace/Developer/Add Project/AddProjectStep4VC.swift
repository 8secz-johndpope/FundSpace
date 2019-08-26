//
//  AddProjectStep4VC.swift
//  FundSpace
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddProjectStep4VC: UIViewController {
    @IBOutlet weak var purchaseTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var buildTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        purchaseTextField.font = UIFont(name: "OpenSans", size: 15)
        buildTextField.font = UIFont(name: "OpenSans", size: 15)
    }
}
