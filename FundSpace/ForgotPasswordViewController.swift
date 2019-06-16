//
//  DeveloperForgotPasswordViewController.swift
//  FundSpace
//
//  Created by admin on 4/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
    }
    
    func initUI() {
        sendBtn.layer.cornerRadius = 6
        emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
        
        emailTextField.delegate = self
    }
    
    @IBAction func sendBtn_Click(_ sender: Any) {
        let email: String = emailTextField.text ?? ""
        if !Helper.sharedInstance.validateEmail(emailStr: email) {
            Helper.sharedInstance.showNotice(_self: self, messageStr: "Please provide the valid email address.")
            return
        }
        SVProgressHUD.show()
        FirebaseService.sharedInstance.resetPasswordWithEmail(email: email) { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let message = error.localizedDescription
                Helper.sharedInstance.showNotice(_self: self, messageStr: message)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
    }
}
