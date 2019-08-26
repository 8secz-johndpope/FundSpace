//
//  AddProjectTitleVC.swift
//  FundSpace
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddProjectStep1VC: UIViewController {

    @IBOutlet weak var projectTtitleTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    

    func initUI() {
        projectTtitleTextField.font = UIFont(name: "OpenSans", size: 15)
    }

}
