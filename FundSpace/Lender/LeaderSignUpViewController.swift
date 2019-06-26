//
//  DeveloperSignUpViewController.swift
//  FundSpace
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SVProgressHUD
import BEMCheckBox
import Atributika

class LeaderSignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var togglePasswordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var termsCheckBox: BEMCheckBox!
    @IBOutlet weak var newsCheckBox: BEMCheckBox!
    @IBOutlet weak var termsView: UIView!
    
    var show_password: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initUI()
    }
    
    func initUI() {
        signupButton.layer.cornerRadius = 6
        emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
        nameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
        passwordView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
        passwordTextField.isSecureTextEntry = !self.show_password
        
        let termsText = "I agree to Fundspace <u>Terms of Service</u> and <u>Privacy Policy</u>"
        let attributeLabel = AttributedLabel()
        attributeLabel.numberOfLines = 0
        let all = Style.font(UIFont(name: "OpenSans", size: 15)!)
            .foregroundColor(.lightGray, .normal)
        let link = Style("u")
            .foregroundColor(.lightGray, .normal)
            .foregroundColor(.blue, .highlighted)
            .underlineStyle(.single, .normal)
            .font(UIFont(name: "OpenSans-Bold", size: 15)!, .normal)
        attributeLabel.attributedText = termsText.style(tags: link).styleAll(all)
        
        attributeLabel.onClick = { label, detection in
            switch detection.type {
            case .tag(let tag):
                if tag.name == "u" {
                    let startIndex = termsText.index(detection.range.lowerBound, offsetBy: 3)
                    let endIndex = termsText.index(detection.range.upperBound, offsetBy: 3)
                    let tagText = String(termsText[startIndex..<endIndex])
                    if tagText == "Terms of Service" {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: 	"termsVC") as! TermsViewController
                        self.navigationController?.pushViewController(newViewController, animated: true)
                    } else {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newsVC") as! NewsViewController
                        self.navigationController?.pushViewController(newViewController, animated: true)
                    }
                }
            default:
                break
            }
        }
        
        termsView.addSubview(attributeLabel)
        
        let marginGuide = termsView.layoutMarginsGuide
        
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraintLeading = attributeLabel.leadingAnchor.constraint(equalTo: termsView.leadingAnchor)
        constraintLeading.constant = 40
        constraintLeading.isActive = true
        attributeLabel.centerYAnchor.constraint(equalTo: termsView.centerYAnchor).isActive = true
        attributeLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func togglePassword_Click(_ sender: Any) {
        self.show_password = !self.show_password
        passwordTextField.isSecureTextEntry = !self.show_password
        if (self.show_password) {
            togglePasswordButton.setImage(UIImage(named: "hide_password.png"), for: .normal)
        } else {
            togglePasswordButton.setImage(UIImage(named: "show_password.png"), for: .normal)
        }
    }
    
    @IBAction func signUpBtn_Click(_ sender: Any) {
        SVProgressHUD.show()
        let name: String = self.nameTextField.text ?? ""
        let emailAddress: String = self.emailTextField.text ?? ""
        let password: String = self.passwordTextField.text ?? ""
        
        if (!Helper.sharedInstance.validateEmail(emailStr: emailAddress)) {
            Helper.sharedInstance.showNotice(_self: self, messageStr: "Please provide the valid email address.")
            return
        }
        
        //        if (!phoneNumber.isEmpty && !Helper.sharedInstance.validatePhone(phoneStr: phoneNumber)) {
        //            Helper.sharedInstance.showNotice(_self: self, messageStr: "Please provide the valid phone number.")
        //            return
        //        }
        
        if (name.isEmpty || password.isEmpty) {
            Helper.sharedInstance.showNotice(_self: self, messageStr: "Please provide all mandatory fields.")
            return
        }
        
        if (!termsCheckBox.on) {
            Helper.sharedInstance.showNotice(_self: self, messageStr: "Please accept the Terms of Service and Privacy Policy.")
            return
        }
        
        var userInfo: [String: Any] = [:]
        userInfo["name"] = name
        userInfo["email"] = emailAddress
        userInfo["password"] = password
        userInfo["type"] = "leader"
        
        FirebaseService.sharedInstance.signUpUser(userInfo: userInfo) { (user, error) in
            SVProgressHUD.dismiss()
            if error == nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "leaderTabVC") as! LeaderTabViewController
                self.present(newViewController, animated: true, completion: nil)
            } else {
                let errorMessage = error?.localizedDescription
                Helper.sharedInstance.showNotice(_self: self, messageStr: errorMessage!)
            }
        }
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.emailTextField:
            emailView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            passwordView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            nameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            break
            
        case self.passwordTextField:
            emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            passwordView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            nameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            break
            
        case self.nameTextField:
            emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            passwordView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            nameView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            break
        default:
            break
        }
    }
    
}
