//
//  utils.swift
//  FundSpace
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SVProgressHUD

class Helper {
    
    static let sharedInstance = Helper()
    
    init() {
        
    }
    
    func validateEmail(emailStr: String = "") -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    func validatePhone(phoneStr: String = "") -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phoneStr)
        return result
    }
    
    func showNotice(_self: UIViewController, messageStr: String) {
        SVProgressHUD.dismiss()
        
        let alert = UIAlertController(title: "Notice", message: messageStr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        _self.present(alert, animated: true, completion: nil)
    }
}
