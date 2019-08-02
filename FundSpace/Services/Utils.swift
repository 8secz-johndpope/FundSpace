//
//  Utils.swift
//  FundSpace
//
//  Created by PUMA on 02/08/2019.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class Utils: NSObject {
    // Define password strength.
    enum PASSWORD: Int {
        case STRONG = 1
        case MEDIUM
        case LOW
    }
    
    static let sharedInstance = Utils()
    
    // Check if email address has valid format.
    func validateEmail(emailStr: String = "") -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    // Measure password strength.
    func measurePasswordStrength(password: String = "") -> PASSWORD {
        if (password.count >= 6) {
            return PASSWORD.STRONG
        } else {
            return PASSWORD.LOW
        }
    }
}
