//
//  BioViewController.swift
//  FundSpace
//
//  Created by admin on 5/27/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class BioViewController: UIViewController {

    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        bioView.setBorder(radius: 6, color: .blue)
        updateBtn.layer.cornerRadius = 6
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func updateBtn_Click(_ sender: Any) {
        if let vc = self.parent as? DeveloperEditProfileViewController {
            vc.update()
        }
    }
    
}
