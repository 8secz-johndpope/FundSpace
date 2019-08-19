//
//  ForgotVC.swift
//  FundSpace
//
//  Created by adnin on 8/12/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class ForgotVC: UIViewController {
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        initEvents()
    }
    
    func initUI() {
        // Reset Password button style
        resetBtn.layer.cornerRadius = 6
        
        // Email textfile style
        emailTextField.font = UIFont(name: "OpenSans", size: 15)
    }
    
    func initEvents() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func resetBtn_Click(_ sender: Any) {
        let email: String = self.emailTextField.text ?? ""
        
        if (email == "") {
            Utils.sharedInstance.showNotice(title: "Notice", message: "You need to fill the email field.")
            return
        }
        
        if (self.emailTextField.errorMessage != "") {
            Utils.sharedInstance.showNotice(title: "Notice", message: "Please input the valid email address")
            return
        }
        
        SVProgressHUD.show()
        FirebaseService.sharedInstance.resetPasswordWithEmail(email: email) { (error) in
            SVProgressHUD.dismiss()
            
            if (error == nil) {
                Utils.sharedInstance.showSuccess(title: "Success", message: "We sent the request to your email to reset the password. Please check it out and reset your password.")
            } else {
                let errorMessage: String = error?.localizedDescription ?? ""
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
            }
        }
    }
    
    // MARK: Events
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingTextField = textfield as? SkyFloatingLabelTextField {
                if (floatingTextField == emailTextField) {
                    if (Utils.sharedInstance.validateEmail(emailStr: text) || text.count == 0) {
                        emailTextField.errorMessage = ""
                        emailTextField.title = "Email"
                    } else {
                        emailTextField.errorMessage = "Invalid email"
                    }
                }
            }
        }
    }
}
