//
//  LeaderProjectOverViewVC.swift
//  FundSpace
//
//  Created by admin on 9/9/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import GoogleMaps
import SVProgressHUD
import SCLAlertView

class LeaderProjectOverViewVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var projectTypeLabel: UILabel!
    @IBOutlet weak var projectTypeView: UIView!
    @IBOutlet weak var projectAddDateTextField: UITextField!
    @IBOutlet weak var projectCompleteTextField: UITextField!
    
    @IBOutlet weak var projectBasicInfoContainerView: UIView!
    @IBOutlet weak var projectBasicInfoView: UIView!
    @IBOutlet weak var projectCapitalCostLabel: UILabel!
    @IBOutlet weak var projectPermissionLabel: UILabel!
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectAddressLabel: UILabel!
    @IBOutlet weak var unitsView: UIView!
    @IBOutlet weak var unitsLabel: UILabel!
    
    @IBOutlet weak var projectInfoView: UIView!
    @IBOutlet weak var projectCurrentView: UIView!
    @IBOutlet weak var projectCurrentLabel: UILabel!
    @IBOutlet weak var projectPurchaseView: UIView!
    @IBOutlet weak var projectPurchaseLabel: UILabel!
    @IBOutlet weak var projectGDVView: UIView!
    @IBOutlet weak var projectGDVLabel: UILabel!
    
    @IBOutlet weak var projectCostsView: UIView!
    @IBOutlet weak var projectCostsTitleView: UIView!
    @IBOutlet weak var projectTotalCostsView: UIView!
    @IBOutlet weak var projectTotalCostsLabel: UILabel!
    @IBOutlet weak var projectStampDutyTextField: UITextField!
    @IBOutlet weak var projectBuildCostTextField: UITextField!
    @IBOutlet weak var projectVATTextField: UITextField!
    @IBOutlet weak var projectLegalsTextField: UITextField!
    @IBOutlet weak var projectValuationTextField: UITextField!
    @IBOutlet weak var projectCILTextField: UITextField!
    @IBOutlet weak var projectFeesTextField: UITextField!
    @IBOutlet weak var projectWarrantiesTextField: UITextField!
    @IBOutlet weak var projectSurveyorTextField: UITextField!
    @IBOutlet weak var projectSalesTextField: UITextField!
    @IBOutlet weak var projectContingencyTextField: UITextField!
    
    @IBOutlet weak var costProfitChartView: MKMagneticProgress!
    @IBOutlet weak var developerProfitView: UIView!
    @IBOutlet weak var developerProfitLabel: UILabel!
    
    @IBOutlet weak var projectExtraInfoView: UIView!
    @IBOutlet weak var projectSecurityTextField: UITextField!
    @IBOutlet weak var projectStrategyTextField: UITextField!
    @IBOutlet weak var projectTermRequiredTextField: UITextField!
    @IBOutlet weak var projectUnitsTextField: UITextField!
    @IBOutlet weak var projectBedroomsTextField: UITextField!
    @IBOutlet weak var projectBathroomsTextField: UITextField!
    @IBOutlet weak var projectTotalSqftTextField: UITextField!
    @IBOutlet weak var projectCostPerSqftTextField: UITextField!
    @IBOutlet weak var projectGDVPerSqftTextField: UITextField!
    @IBOutlet weak var projectPlanningTextField: UITextField!
    @IBOutlet weak var projectTenureTextField: UITextField!
    @IBOutlet weak var projectBuildDurationTextField: UITextField!
    
    @IBOutlet weak var projectBuildingContractorView: UIView!
    @IBOutlet weak var firstContractorTextField: UITextField!
    @IBOutlet weak var secondContractorTextField: UITextField!
    @IBOutlet weak var thirdContractorTextField: UITextField!
    
    @IBOutlet weak var projectArchitectView: UIView!
    @IBOutlet weak var firstArchitectTextField: UITextField!
    @IBOutlet weak var secondArchitectTextField: UITextField!
    @IBOutlet weak var thirdArchitectTextField: UITextField!
    
    @IBOutlet weak var projectSolicitorView: UIView!
    @IBOutlet weak var firstSolicitorTextField: UITextField!
    @IBOutlet weak var secondSolicitorTextField: UITextField!
    @IBOutlet weak var thirdSolicitorTextField: UITextField!
    
    @IBOutlet weak var projectEngineerView: UIView!
    @IBOutlet weak var firstEngineerTextField: UITextField!
    @IBOutlet weak var secondEngineerTextField: UITextField!
    @IBOutlet weak var thirdEngineerTextField: UITextField!
    
    @IBOutlet weak var projectComparablePropertiesView: UIView!
    
    @IBOutlet weak var developerInfoView: UIView!
    @IBOutlet weak var developerProfileImageView: UIImageView!
    @IBOutlet weak var developerProfileImageBtn: UIButton!
    @IBOutlet weak var developerNameLabel: UILabel!
    @IBOutlet weak var developerCompanyLabel: UILabel!
    @IBOutlet weak var developerLocationLabel: UILabel!
    
    
    @IBOutlet weak var uploadDocumentBtn: UIButton!
    @IBOutlet weak var exportProjectBtn: UIButton!
    
    @IBOutlet weak var sendTermsBtn: UIButton!
    
    var projectID: String = ""
    var projectInfo: [String: Any] = [:]
    var userInfo: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initUI()
        loadProjectInfo()
    }
    
    func initUI() {
        let borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        projectTypeView.layer.cornerRadius = 3
        projectTypeView.layer.borderColor = UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1).cgColor
        projectTypeView.layer.borderWidth = 1
        
        projectBasicInfoContainerView.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 0.5)
        projectBasicInfoView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        
        projectInfoView.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 0.5)
        projectCurrentView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        projectPurchaseView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        projectGDVView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        
        projectCostsView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        projectCostsTitleView.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 0.5)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = projectTotalCostsView.frame
        rectShape.position = projectTotalCostsView.center
        rectShape.path = UIBezierPath(roundedRect: projectTotalCostsView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        projectTotalCostsView.layer.mask = rectShape
        
        costProfitChartView.orientation = .top
        developerProfitView.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        developerProfitView.layer.borderWidth = 6
        developerProfitView.layer.cornerRadius = developerProfitView.bounds.width / 2
        
        projectExtraInfoView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        
        projectBuildingContractorView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        projectArchitectView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        projectSolicitorView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        projectEngineerView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        
        projectComparablePropertiesView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        
        developerInfoView.makeRoundShadowView(cornerRadius: 5, shadowRadius: 14)
        
        uploadDocumentBtn.layer.cornerRadius = 4
        exportProjectBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        exportProjectBtn.layer.cornerRadius = 4
        exportProjectBtn.layer.borderWidth = 1
        
        developerProfileImageView.layer.masksToBounds = true
        developerProfileImageView.layer.cornerRadius = developerProfileImageView.bounds.width / 2
        developerProfileImageBtn.setImage(UIImage(named: "circle_border"), for: .normal)
        
        sendTermsBtn.layer.cornerRadius = 4
        
        let position = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
        let london = GMSMarker(position: position)
        london.title = "London"
        london.icon = UIImage(named: "pin")
        london.map = mapView
    }
    
    func loadProjectInfo() {
        SVProgressHUD.show()
        FirebaseService.sharedInstance.getProjectByID(id: projectID) { (data, error) in
            if let error = error {
                SVProgressHUD.dismiss()
                let errorMsg = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMsg)
                return
            }
            
            FirebaseService.sharedInstance.getUserInfo(id: (data["userID"] as! String), completion: { (userInfo, error) in
                if let error = error {
                    SVProgressHUD.dismiss()
                    let errorMsg = error.localizedDescription
                    Utils.sharedInstance.showError(title: "Error", message: errorMsg)
                    return
                }
                
                let profileImagePath: String = userInfo!["profile_pic"] != nil ? userInfo!["profile_pic"] as! String : ""
                
                if (profileImagePath == "") {
                    SVProgressHUD.dismiss()
                    self.developerProfileImageView.image = UIImage(named: "default_avatar")
                } else {
                    FirebaseService.sharedInstance.downloadImage(path: profileImagePath) { (imageData, error) in
                        SVProgressHUD.dismiss()
                        if let error = error {
                            let errorMessage: String = error.localizedDescription
                            Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                            self.developerProfileImageView.image = UIImage(named: "default_avatar")
                        } else {
                            let image = UIImage(data: imageData!)
                            self.developerProfileImageView.image = image
                        }
                    }
                }
                
                self.userInfo = userInfo!
                self.projectInfo = data
                self.applyDataToUI()
            })
        }
    }
    
    func applyDataToUI() {
        projectAddDateTextField.text = projectInfo["added"] as? String ?? ""
        projectCompleteTextField.text = projectInfo["complete"] as? String ?? ""
        
        projectTypeLabel.text = projectInfo["type"] as? String ?? ""
        projectCapitalCostLabel.text = projectInfo["contribute"] as? String ?? ""
        projectPermissionLabel.text = projectInfo["hasFullPermission"] as? Bool ?? true ? "Total funding required" : ""
        projectTitleLabel.text = projectInfo["title"] as? String ?? ""
        projectAddressLabel.text = projectInfo["street"] as? String ?? ""
        
        let units: Int = projectInfo["units"] as? Int ?? 0
        
        if units == 0 {
            unitsView.isHidden = true
        } else {
            unitsView.isHidden = false
            unitsLabel.text = "x"+String(units)
        }
        
        projectCurrentLabel.text = projectInfo["current"] as? String ?? ""
        projectPurchaseLabel.text = projectInfo["purchase"] as? String ?? ""
        projectGDVLabel.text = projectInfo["gdv"] as? String ?? ""
        
        projectStampDutyTextField.text = projectInfo["stampDuty"] as? String ?? ""
        projectBuildCostTextField.text = projectInfo["build"] as? String ?? ""
        projectVATTextField.text = projectInfo["vat"] as? String ?? ""
        projectLegalsTextField.text = projectInfo["legals"] as? String ?? ""
        projectValuationTextField.text = projectInfo["valuation"] as? String ?? ""
        projectCILTextField.text = projectInfo["cil"] as? String ?? ""
        projectFeesTextField.text = projectInfo["fees"] as? String ?? ""
        projectWarrantiesTextField.text = projectInfo["warranties"] as? String ?? ""
        projectSurveyorTextField.text = projectInfo["surveyor"] as? String ?? ""
        projectSalesTextField.text = projectInfo["sales"] as? String ?? ""
        projectContingencyTextField.text = projectInfo["contingency"] as? String ?? ""
        
        projectUnitsTextField.text = projectInfo["units"] as? String ?? ""
        projectBedroomsTextField.text = projectInfo["bedrooms"] as? String ?? ""
        projectBathroomsTextField.text = projectInfo["bathrooms"] as? String ?? ""
        
        projectTotalSqftTextField.text = projectInfo["totalSqft"] as? String ?? ""
        projectGDVPerSqftTextField.text = projectInfo["gdvPerSqft"] as? String ?? ""
        projectCostPerSqftTextField.text = projectInfo["costPerSqft"] as? String ?? ""
        
        projectSecurityTextField.text = projectInfo["securityType"] as? Int ?? 1 == 1 ? "1st charge" : "2nd charge"
        projectPlanningTextField.text = projectInfo["planning"] as? String ?? ""
        projectStrategyTextField.text = projectInfo["strategy"] as? String ?? ""
        projectTenureTextField.text = projectInfo["tenure"] as? String ?? ""
        projectTermRequiredTextField.text = projectInfo["terms"] as? String ?? ""
        projectBuildDurationTextField.text = projectInfo["duration"] as? String ?? ""
        
        let contractor: [String: Any] = projectInfo["contractor"] as? [String: Any] ?? [:]
        firstContractorTextField.text = contractor["first"] as? String ?? ""
        secondContractorTextField.text = contractor["second"] as? String ?? ""
        thirdContractorTextField.text = contractor["third"] as? String ?? ""
        
        let architect: [String: Any] = projectInfo["architect"] as? [String: Any] ?? [:]
        firstArchitectTextField.text = architect["first"] as? String ?? ""
        secondArchitectTextField.text = architect["second"] as? String ?? ""
        thirdArchitectTextField.text = architect["third"] as? String ?? ""
        
        let solicitor: [String: Any] = projectInfo["solicitor"] as? [String: Any] ?? [:]
        firstSolicitorTextField.text = solicitor["first"] as? String ?? ""
        secondSolicitorTextField.text = solicitor["second"] as? String ?? ""
        thirdSolicitorTextField.text = solicitor["third"] as? String ?? ""
        
        let engineers: [String: Any] = projectInfo["engineer"] as? [String: Any] ?? [:]
        firstEngineerTextField.text = engineers["first"] as? String ?? ""
        secondEngineerTextField.text = engineers["second"] as? String ?? ""
        thirdEngineerTextField.text = engineers["third"] as? String ?? ""
        
        updateProfit()
        
        developerNameLabel.text = userInfo["name"] as? String ?? ""
        developerCompanyLabel.text = userInfo["companyName"] as? String ?? ""
        developerLocationLabel.text = userInfo["location"] as? String ?? ""
    }
    
    func updateProfit() {
        let stamp: Int = Int(projectStampDutyTextField.text ?? "") ?? 0
        let build: Int = Int(projectBuildCostTextField.text ?? "") ?? 0
        let vat: Int = Int(projectVATTextField.text ?? "") ?? 0
        let legals: Int = Int(projectLegalsTextField.text ?? "") ?? 0
        let valuation: Int = Int(projectValuationTextField.text ?? "") ?? 0
        let cil: Int = Int(projectCILTextField.text ?? "") ?? 0
        let fees: Int = Int(projectFeesTextField.text ?? "") ?? 0
        let surveyor: Int = Int(projectSurveyorTextField.text ?? "") ?? 0
        let sales: Int = Int(projectSalesTextField.text ?? "") ?? 0
        let contingency: Int = Int(projectContingencyTextField.text ?? "") ?? 0
        
        let totalCost: Int = stamp + build + vat + legals + valuation + cil + fees + surveyor + sales + contingency
        
        projectTotalCostsLabel.text = String(totalCost)
        
        let GDV: Int = Int(projectGDVLabel.text ?? "") ?? 0
        
        let developerProfit: Int = GDV - totalCost
        developerProfitLabel.text = String(developerProfit)
        
        let profitCost: CGFloat = CGFloat(developerProfit) / CGFloat(totalCost)
        costProfitChartView.setProgress(progress: profitCost)
    }
    
    func makeEditable(_ flag: Bool) {
        projectAddDateTextField.isEnabled = flag
        projectCompleteTextField.isEnabled = flag
        projectStampDutyTextField.isEnabled = flag
        projectBuildCostTextField.isEnabled = flag
        projectVATTextField.isEnabled = flag
        projectLegalsTextField.isEnabled = flag
        projectValuationTextField.isEnabled = flag
        projectCILTextField.isEnabled = flag
        projectFeesTextField.isEnabled = flag
        projectWarrantiesTextField.isEnabled = flag
        projectSurveyorTextField.isEnabled = flag
        projectSalesTextField.isEnabled = flag
        projectContingencyTextField.isEnabled = flag
        projectUnitsTextField.isEnabled = flag
        projectBedroomsTextField.isEnabled = flag
        projectBathroomsTextField.isEnabled = flag
        projectSecurityTextField.isEnabled = flag
        projectStrategyTextField.isEnabled = flag
        projectTermRequiredTextField.isEnabled = flag
        projectTotalSqftTextField.isEnabled = flag
        projectGDVPerSqftTextField.isEnabled = flag
        projectCostPerSqftTextField.isEnabled = flag
        projectPlanningTextField.isEnabled = flag
        projectTenureTextField.isEnabled = flag
        projectBuildDurationTextField.isEnabled = flag
        firstContractorTextField.isEnabled = flag
        secondContractorTextField.isEnabled = flag
        thirdContractorTextField.isEnabled = flag
        firstArchitectTextField.isEnabled = flag
        secondArchitectTextField.isEnabled = flag
        thirdArchitectTextField.isEnabled = flag
        firstSolicitorTextField.isEnabled = flag
        secondSolicitorTextField.isEnabled = flag
        thirdSolicitorTextField.isEnabled = flag
        firstEngineerTextField.isEnabled = flag
        secondEngineerTextField.isEnabled = flag
        thirdEngineerTextField.isEnabled = flag
    }
    
    @IBAction func uploadDocumentBtn_Click(_ sender: Any) {
    }
    
    @IBAction func expertProjectBtn_Click(_ sender: Any) {
        
    }
    
    @IBAction func sendTermsBtn_Click(_ sender: Any) {
    }
}
