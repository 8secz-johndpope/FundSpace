//
//  DeveloperLogInViewController.swift
//  FundSpace
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import SVProgressHUD
import GoogleSignIn
import Firebase

class LeaderLogInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleBtn: GIDSignInButton!
    
    var show_password: Bool = false
    
    private let readPermissions: [ReadPermission] = [ .publicProfile, .email]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initUI()
    }
    
    func initUI() {
        loginButton.layer.cornerRadius = 6
        emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
        passwordView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
        passwordTextField.isSecureTextEntry = !self.show_password
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginBtn_Click(_ sender: Any) {
        SVProgressHUD.show()
        
        let email: String = self.emailTextField.text ?? ""
        let password: String = self.passwordTextField.text ?? ""
        
        FirebaseService.sharedInstance.logInUser(email: email, password: password) { (user, error) in
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
    
    @IBAction func googleBtn_Click(_ sender: Any) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookBtn_Click(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: readPermissions, viewController: self, completion: didReceiveFacebookLoginResult)
    }
    
    private func didReceiveFacebookLoginResult(loginResult: LoginResult) {
        switch loginResult {
        case .success:
            didLoginWithFacebook()
        case .failed(_): break
        default: break
        }
    }
    
    fileprivate func didLoginWithFacebook() {
        // Successful log in with Facebook
        if let accessToken = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken as! String)
            
            var userInfo: [String: Any] = [:]
            
            FirebaseService.sharedInstance.logInWithSocial(credential: credential, userInfo: userInfo) { (user, error) in
                if let error = error {
                    let message = error.localizedDescription
                    Helper.sharedInstance.showNotice(_self: self, messageStr: message)
                    return
                } else {
                    Helper.sharedInstance.showNotice(_self: self, messageStr: "Success with Google")
                    return
                }
            }
        }
    }
    
    @IBAction func togglePasswordBtn_Click(_ sender: Any) {
        self.show_password = !self.show_password
        passwordTextField.isSecureTextEntry = !self.show_password
        if (self.show_password) {
            showPasswordBtn.setImage(UIImage(named: "hide_password.png"), for: .normal)
        } else {
            showPasswordBtn.setImage(UIImage(named: "show_password.png"), for: .normal)
        }
    }
    
    // MARK: - Google SignIn Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            let message = error.localizedDescription
            Helper.sharedInstance.showNotice(_self: self, messageStr: message)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        let email: String = user.profile.email
        let name: String = user.profile.name
        
        let userInfo: [String: Any] = [
            "name": name,
            "email": email,
            "type": "leader"
        ]
        
        FirebaseService.sharedInstance.logInWithSocial(credential: credential, userInfo: userInfo) { (user, error) in
            if let error = error {
                let message = error.localizedDescription
                Helper.sharedInstance.showNotice(_self: self, messageStr: message)
                return
            } else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "leaderTabVC") as! LeaderTabViewController
                self.present(newViewController, animated: true, completion: nil)
                return
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.emailTextField:
            emailView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            passwordView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.passwordTextField:
            emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            passwordView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            break
        default:
            break
        }
    }
}
