//
//  SendTermsVC.swift
//  FundSpace
//
//  Created by admin on 9/11/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import Atributika
import SVProgressHUD

class SendTermsVC: UIViewController {
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectAddressLabel: UILabel!
    @IBOutlet weak var projectReferenceView: UIView!
    @IBOutlet weak var projectReferenceLabel: UILabel!
    @IBOutlet weak var projectUnitsView: UIView!
    @IBOutlet weak var projectUnitsLabel: UILabel!
    
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var termsTextField: UITextField!
    @IBOutlet weak var developmentFacilityTextField: UITextField!
    @IBOutlet weak var totalFacilityTextField: UITextField!
    @IBOutlet weak var ltvTextField: UITextField!
    @IBOutlet weak var monthlyRateTextField: UITextField!
    @IBOutlet weak var arrangementFeeTextField: UITextField!
    @IBOutlet weak var exitFeeTextField: UITextField!
    @IBOutlet weak var netAdvanceTextField: UITextField!
    @IBOutlet weak var dayAdvanceTextField: UITextField!
    
    @IBOutlet weak var footerView: UIView!
    
    var rightNavButtonItem: UIBarButtonItem!
    
    var projectInfo: [String: Any] = [:]
    var userId: String = ""
    var projectId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.none)
        initUI()
        loadData()
    }
    
    func initUI() {
        projectReferenceView.clipsToBounds = true
        projectReferenceView.layer.cornerRadius = 6
        projectReferenceView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        termsView.addBottomBorder(color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), margins: 0, borderLineSize: 1)
        
        // Place footer text
        let footerText = "If you would prefer to send terms from your desktop or mobile email account, simply quote the project reference in your email subject and address your email to <u>terms@fundspace.co.uk</u>"
        let attributeLabel = AttributedLabel()
        attributeLabel.numberOfLines = 0
        let font = UIFont(name: "OpenSans", size: 10)!
        let fontColor = UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1)
        let all = Style.font(font)
            .foregroundColor(fontColor, .normal)
        let link = Style("u")
            .foregroundColor(fontColor, .normal)
            .foregroundColor(fontColor, .highlighted)
            .underlineStyle(.single, .normal)
            .font(font, .normal)
        attributeLabel.attributedText = footerText.style(tags: link).styleAll(all)
        
        attributeLabel.onClick = { label, detection in
            switch detection.type {
            case .tag(let tag):
                if tag.name == "u" {
                    
                }
            default:
                break
            }
        }
        
        footerView.addSubview(attributeLabel)
        
        let marginGuide = footerView.layoutMarginsGuide
        
        attributeLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraintLeading = attributeLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor)
        constraintLeading.constant = 0
        constraintLeading.isActive = true
        attributeLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        attributeLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        rightNavButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(self.sendTermsAction))
        navigationItem.rightBarButtonItem = rightNavButtonItem
    }
    
    func loadData() {
        projectTitleLabel.text = projectInfo["title"] as? String ?? ""
        projectAddressLabel.text = projectInfo["street"] as? String ?? ""
        
        projectReferenceLabel.text = projectInfo["reference"] as? String ?? ""
        
        let units: Int = Int(projectInfo["units"] as? String ?? "") ?? 0
        
        if units == 0 {
            projectUnitsView.isHidden = true
        } else {
            projectUnitsView.isHidden = false
            projectUnitsLabel.text = "x"+String(units)
        }
    }
    
    func sendNotification() {
        let notification = [
            "receiver": userId,
            "type": "terms"
        ]
        
        FirebaseService.sharedInstance.sendNotification(notificationInfo: notification) { (error) in
            
        }
    }
    
    @objc func sendTermsAction() {
        let product: String = productTextField.text ?? ""
        let term: String = termsTextField.text ?? ""
        let developmentFacility: String = developmentFacilityTextField.text ?? ""
        let totalFacility: String = totalFacilityTextField.text ?? ""
        let ltv: String = ltvTextField.text ?? ""
        let monthlyRate: String = monthlyRateTextField.text ?? ""
        let arrangementFee: String = arrangementFeeTextField.text ?? ""
        let exitFee: String = exitFeeTextField.text ?? ""
        let netAdvance: String = netAdvanceTextField.text ?? ""
        let dayAdvance: String = dayAdvanceTextField.text ?? ""
        
        let termsInfo = [
            "product": product,
            "term": term,
            "developmentFacility": developmentFacility,
            "totalFacility": totalFacility,
            "ltv": ltv,
            "monthlyRate": monthlyRate,
            "arrangementFee": arrangementFee,
            "exitFee": exitFee,
            "netAdvance": netAdvance,
            "dayAdvance": dayAdvance,
            "project": projectId,
            "developer": userId
        ]
        SVProgressHUD.show()
        FirebaseService.sharedInstance.sendTerms(termsInfo: termsInfo) { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let errorMessage = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            
            self.sendNotification()
            Utils.sharedInstance.showSuccess(title: "Success", message: "Terms has been posted successfully.")
        }
    }
}
