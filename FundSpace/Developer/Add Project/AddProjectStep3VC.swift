//
//  AddProjectStep3VC.swift
//  FundSpace
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddProjectStep3VC: UIViewController {
    @IBOutlet weak var streetTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var postalTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        streetTextField.font = UIFont(name: "OpenSans", size: 15)
        cityTextField.font = UIFont(name: "OpenSans", size: 15)
        countyTextField.font = UIFont(name: "OpenSans", size: 15)
        postalTextField.font = UIFont(name: "OpenSans", size: 15)
    }
}
