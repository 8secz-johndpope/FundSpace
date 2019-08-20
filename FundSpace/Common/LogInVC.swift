//
//  ViewController.swift
//  FundSpace
//
//  Created by PUMA on 02/08/2019.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import GoogleSignIn
import Firebase

class LogInVC: UIViewController, GIDSignInDelegate {
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userTypeBtn: UIButton!
    @IBOutlet weak var googleBtn: GIDSignInButton!
    
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
        emailTextField.font = UIFont(name: "OpenSans", size: 15)
        
        // Password textfield style
        passwordTextField.font = UIFont(name: "OpenSans", size: 15)
        passwordTextField.isSecureTextEntry = !_showPassword
        
        // Add show password button to password textfield
        showPasswordBtn = UIButton(type: .custom)
        showPasswordBtn.setImage(UIImage(named: "show_password.png"), for: .normal)
        showPasswordBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        showPasswordBtn.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        showPasswordBtn.addTarget(self, action: #selector(self.togglePassword), for: .touchUpInside)
        passwordTextField.rightView = showPasswordBtn
        passwordTextField.rightViewMode = .always
        
        // Set user type to UserDefaults
        UserDefaults.standard.set(true, forKey: "isDeveloper")
    }
    
    // Initialize the events
    func initEvents() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // MARK: Button Actions
    @IBAction func signupBtn_Click(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "singupVC") as! SignUpVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func forgotPasswordBtn_Click(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "forgotVC") as! ForgotVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func loginBtn_Click(_ sender: Any) {
        let email: String = self.emailTextField.text ?? ""
        let password: String = self.passwordTextField.text ?? ""
        
        if (email == "" || password == "") {
            Utils.sharedInstance.showNotice(title: "Notice", message: "You need to fill all fields.")
            return
        }
        
        if (self.emailTextField.errorMessage != "" && self.emailTextField.errorMessage != nil) {
            Utils.sharedInstance.showNotice(title: "Notice", message: "Please input the valid email address")
            return
        }
        
        if (self.passwordTextField.errorMessage != "" && self.passwordTextField.errorMessage != nil) {
            Utils.sharedInstance.showNotice(title: "Notice", message: "Please input the strong password.")
            return
        }
        
        SVProgressHUD.show()
        FirebaseService.sharedInstance.logInUser(email: email, password: password) { (user, error) in
            SVProgressHUD.dismiss()
            if error == nil {
                let isDeveloper: Bool = UserDefaults.standard.bool(forKey: "isDeveloper")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = isDeveloper ?
                                            storyBoard.instantiateViewController(withIdentifier: "developerTabVC") as! DeveloperTabBarController :
                                            storyBoard.instantiateViewController(withIdentifier: "developerTabVC") as! DeveloperTabBarController
                    
                self.present(newViewController, animated: true, completion: nil)
            } else {
                let errorMessage: String = error?.localizedDescription ?? ""
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
            }
        }
    }
    
    @IBAction func googleBtn_Click(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
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
        
        // set User Type to UserDefaults.
        UserDefaults.standard.set(_isDeveloper, forKey: "isDeveloper")
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
    
    // MARK: Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            let message = error.localizedDescription
            Utils.sharedInstance.showError(title: "Error", message: message)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        let email: String = user.profile.email
        let name: String = user.profile.name
        
        let type: Bool = UserDefaults.standard.bool(forKey: "isDeveloper")
        
        var userInfo: [String: Any] = [:]
        userInfo["name"] = name
        userInfo["email"] = email
        userInfo["type"] = type ? "Developer" : "Leader"
        userInfo["acceptNews"] = true
        
        FirebaseService.sharedInstance.logInWithSocial(credential: credential, userInfo: userInfo) { (user, error) in
            if let error = error {
                let message = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: message)
                return
            } else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = type ?
                    storyBoard.instantiateViewController(withIdentifier: "developerTabVC") as! DeveloperTabBarController :
                    storyBoard.instantiateViewController(withIdentifier: "developerTabVC") as! DeveloperTabBarController
                self.present(newViewController, animated: true, completion: nil)
                return
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
