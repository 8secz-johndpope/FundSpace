//
//  AddProjectStep5VC.swift
//  FundSpace
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddProjectStep5VC: UIViewController {
    @IBOutlet weak var currentTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var gdvTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        currentTextField.font = UIFont(name: "OpenSans", size: 15)
        gdvTextField.font = UIFont(name: "OpenSans", size: 15)
    }
}
