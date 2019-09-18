//
//  SignUpVC.swift
//  FundSpace
//
//  Created by PUMA on 02/08/2019.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import BEMCheckBox
import Atributika
import SVProgressHUD

class SignUpVC: UIViewController {
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var termsCheckBox: BEMCheckBox!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var newsCheckBox: BEMCheckBox!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var showPasswordBtn: UIButton!
    var _showPassword: Bool = false // Determine if password is visible.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        initUI()
        initEvents()
    }
    
    // Initialize the screen
    func initUI() {
        // SignUp button style
        signUpBtn.layer.cornerRadius = 6
        
        // Name textfield style
        nameTextField.font = UIFont(name: "OpenSans", size: 15)
        
        // Email textfile style
        emailTextField.font = UIFont(name: "OpenSans", size: 15)
        
        // Password textfield style
        passwordTextField.font = UIFont(name: "OpenSans", size: 15)
        passwordTextField.isSecureTextEntry = !_showPassword
        
        showPasswordBtn = UIButton(type: .custom)
        showPasswordBtn.setImage(UIImage(named: "show_password.png"), for: .normal)
        showPasswordBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        showPasswordBtn.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        showPasswordBtn.addTarget(self, action: #selector(self.togglePassword), for: .touchUpInside)
        passwordTextField.rightView = showPasswordBtn
        passwordTextField.rightViewMode = .always
        
        // Place terms text
        let termsText = "I agree to Fundspace <u>Terms of Service</u> and <u>Privacy Policy</u>"
        let attributeLabel = AttributedLabel()
        attributeLabel.numberOfLines = 0
        let font = UIFont(name: "OpenSans", size: 14)!
        let tagFont = UIFont(name: "OpenSans-Bold", size: 14)!
        let all = Style.font(font)
            .foregroundColor(.lightGray, .normal)
        let link = Style("u")
            .foregroundColor(.lightGray, .normal)
            .foregroundColor(.lightGray, .highlighted)
            .underlineStyle(.single, .normal)
            .font(tagFont, .normal)
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
                        let termsVC = storyBoard.instantiateViewController(withIdentifier: "termsVC") as! TermsVC
                        self.navigationController?.pushViewController(termsVC, animated: true)
                    } else {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let privacyVC = storyBoard.instantiateViewController(withIdentifier: "privacyVC") as! PrivacyVC
                        self.navigationController?.pushViewController(privacyVC, animated: true)
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
        constraintLeading.constant = 0
        constraintLeading.isActive = true
        attributeLabel.centerYAnchor.constraint(equalTo: termsView.centerYAnchor).isActive = true
        attributeLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    }
    
    // Initialize the events
    func initEvents() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @IBAction func signUpBtn_Click(_ sender: Any) {
        let name: String = self.nameTextField.text ?? ""
        let email: String = self.emailTextField.text ?? ""
        let password: String = self.passwordTextField.text ?? ""
        
        if (name == "" || email == "" || password == "") {
            Utils.sharedInstance.showNotice(title: "Notice", message: "You need to fill all fields.")
            return
        }
        
        if (self.emailTextField.errorMessage != "") {
            Utils.sharedInstance.showNotice(title: "Notice", message: "Please input the valid email address")
            return
        }
        
        if (self.passwordTextField.errorMessage != "") {
            Utils.sharedInstance.showNotice(title: "Notice", message: "Please input the strong password.")
            return
        }
        
        let _acceptTerms: Bool = self.termsCheckBox.on
        let _acceptNews: Bool = self.newsCheckBox.on 
        
        if (!_acceptTerms) {
            Utils.sharedInstance.showNotice(title: "Notice", message: "Please accept the terms of use and privacy policy to create your account.")
            return
        }
        
        let type: Bool = UserDefaults.standard.bool(forKey: "isDeveloper")
        
        var userInfo: [String: Any] = [:]
        userInfo["name"] = name
        userInfo["email"] = email
        userInfo["password"] = password
        userInfo["type"] = type ? "Developer" : "Leader"
        userInfo["acceptNews"] = _acceptNews
        
        SVProgressHUD.show()
        
        FirebaseService.sharedInstance.signUpUser(userInfo: userInfo) { (user, error) in
            SVProgressHUD.dismiss()
            if error == nil {
                userInfo.removeValue(forKey: "password")
                UserDefaults.standard.set(userInfo, forKey: "userInfo")
                
                Utils.sharedInstance.showSuccess(title: "Success", message: "Your account was created successfully.")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = type ?
                    storyBoard.instantiateViewController(withIdentifier: "getStartedDeveloperVC") as! GetStartedDeveloperVC :
                    storyBoard.instantiateViewController(withIdentifier: "getStartedLeaderVC") as! GetStartedLeaderVC
                self.navigationController?.pushViewController(newViewController, animated: true)
            } else {
                let errorMessage: String = error?.localizedDescription ?? ""
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
            }
        }
    }
    
    @IBAction func togglePassword(_ sender: Any) {
        self._showPassword = !self._showPassword
        passwordTextField.isSecureTextEntry = !self._showPassword
        if (self._showPassword) {
            showPasswordBtn.setImage(UIImage(named: "hide_password.png"), for: .normal)
        } else {
            showPasswordBtn.setImage(UIImage(named: "show_password.png"), for: .normal)
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
                } else {
                    if (Utils.sharedInstance.measurePasswordStrength(password: text) != Utils.PASSWORD.LOW || text.count == 0) {
                        passwordTextField.errorMessage = ""
                        passwordTextField.title = "Password"
                    } else {
                        passwordTextField.errorMessage = "Weak"
                    }
                }
            }
        }
    }
    
}
