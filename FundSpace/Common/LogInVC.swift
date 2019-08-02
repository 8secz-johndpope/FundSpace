//
//  ViewController.swift
//  FundSpace
//
//  Created by PUMA on 02/08/2019.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LogInVC: UIViewController {
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userTypeBtn: UIButton!
    
    var showPasswordBtn: UIButton!
    var _showPassword: Bool = false // Determine if password is visible.
    var _isDeveloper: Bool = true // Determine if user is developer or not.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initUI()
        initEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide Navigation Bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Initialize the screen
    func initUI() {
        // Login button style
        loginBtn.layer.cornerRadius = 6
        
        // Email textfile style
        emailTextField.font = UIFont(name: "Open Sans Regular", size: 17)
        
        // Password textfield style
        passwordTextField.font = UIFont(name: "Open Sans Regular", size: 17)
        passwordTextField.isSecureTextEntry = !_showPassword
        
        showPasswordBtn = UIButton(type: .custom)
        showPasswordBtn.setImage(UIImage(named: "show_password.png"), for: .normal)
        showPasswordBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        showPasswordBtn.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        showPasswordBtn.addTarget(self, action: #selector(self.togglePassword), for: .touchUpInside)
        passwordTextField.rightView = showPasswordBtn
        passwordTextField.rightViewMode = .always
    }
    
    // Initialize the events
    func initEvents() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: Button Actions
    @IBAction func signupBtn_Click(_ sender: Any) {
        let signupVC = SignUpVC()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func forgotPasswordBtn_Click(_ sender: Any) {
    }
    
    @IBAction func loginBtn_Click(_ sender: Any) {
    }
    
    @IBAction func googleBtn_Click(_ sender: Any) {
    }
    
    @IBAction func facebookBtn_Click(_ sender: Any) {
    }
    
    @IBAction func userTypeBtn_Click(_ sender: Any) {
        if (_isDeveloper) {
            userTypeBtn.setTitle("Are you a developer?", for: .normal)
        } else {
            userTypeBtn.setTitle("Are you a lender?", for: .normal)
        }
        
        emailTextField.text = ""
        emailTextField.errorMessage = ""
        passwordTextField.text = ""
        passwordTextField.errorMessage = ""
        _isDeveloper = !_isDeveloper
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

