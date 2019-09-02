//
//  DeveloperProjectOverVC.swift
//  FundSpace
//
//  Created by admin on 8/27/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import GoogleMaps

class DeveloperProjectOverViewVC: UIViewController {

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
    
    @IBOutlet weak var uploadDocumentBtn: UIButton!
    @IBOutlet weak var deleteProjectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
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
        
        uploadDocumentBtn.layer.cornerRadius = 4
        deleteProjectBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        deleteProjectBtn.layer.cornerRadius = 4
        deleteProjectBtn.layer.borderWidth = 1
        
        let position = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.127)
        let london = GMSMarker(position: position)
        london.title = "London"
        london.icon = UIImage(named: "pin")
        london.map = mapView
        
    }
}
