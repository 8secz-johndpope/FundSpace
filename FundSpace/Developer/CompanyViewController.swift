//
//  CompanyViewController.swift
//  FundSpace
//
//  Created by admin on 5/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextfField: UITextField!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyNumberView: UIView!
    @IBOutlet weak var companyNumberTextField: UITextField!
    @IBOutlet weak var shareholderView: UIView!
    @IBOutlet weak var shareholderTextField: UITextField!
    @IBOutlet weak var otherShareholderView: UIView!
    @IBOutlet weak var otherShareholderTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initUI()
    }
    
    func initUI() {
        emailView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        companyNameView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        companyNumberView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        shareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        otherShareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        
        emailTextfField.delegate = self
        companyNameTextField.delegate = self
        companyNumberTextField.delegate = self
        shareholderTextField.delegate = self
        otherShareholderTextField.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.emailTextfField:
            emailView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            companyNameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNumberView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            shareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            otherShareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.companyNameTextField:
            emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNameView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            companyNumberView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            shareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            otherShareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.companyNumberTextField:
            emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNumberView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            shareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            otherShareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.shareholderTextField:
            emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNumberView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            shareholderView.addBottomBorder(color: .blue, margins: 0.0, borderLineSize: 1.5)
            otherShareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.otherShareholderTextField:
            emailView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            companyNumberView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            shareholderView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            otherShareholderView.addBottomBorder(color: .blue, margins: 0.0, borderLineSize: 1.5)
        default:
            break
        }
    }

}
