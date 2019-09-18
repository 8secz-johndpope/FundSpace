//
//  AddProjectVC.swift
//  FundSpace
//
//  Created by admin on 8/25/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import M13ProgressSuite
import SVProgressHUD
import SCLAlertView

class AddProjectVC: UIViewController {
    @IBOutlet weak var progressBar: M13ProgressViewBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    
    var step: Int = 1
    
    private lazy var addProjectStep1VC: AddProjectStep1VC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProjectStep1VC") as! AddProjectStep1VC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var addProjectStep2VC: AddProjectStep2VC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProjectStep2VC") as! AddProjectStep2VC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var addProjectStep3VC: AddProjectStep3VC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProjectStep3VC") as! AddProjectStep3VC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var addProjectStep4VC: AddProjectStep4VC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProjectStep4VC") as! AddProjectStep4VC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var addProjectStep5VC: AddProjectStep5VC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProjectStep5VC") as! AddProjectStep5VC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var addProjectStep6VC: AddProjectStep6VC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProjectStep6VC") as! AddProjectStep6VC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var addProjectStep7VC: AddProjectStep7VC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "addProjectStep7VC") as! AddProjectStep7VC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        initUI()
        
        self.add(asChildViewController: addProjectStep1VC)
    }
    
    func initUI() {
        progressBar.setProgress(CGFloat(step)/7, animated: true)
        progressBar.showPercentage = false
        nextBtn.layer.cornerRadius = 4
        prevBtn.layer.cornerRadius = 4
        prevBtn.isHidden = true
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    func shareProject() {
        let title: String = addProjectStep1VC.projectTitleTextField.text ?? ""
        let type: String = addProjectStep2VC.fundingTypeTextField.text ?? ""
        let hasFullPermission: Bool = addProjectStep2VC.fullPermissionTextField.text == "No" ? false : true
        let street: String = addProjectStep3VC.streetTextField.text ?? ""
        let city: String = addProjectStep3VC.cityTextField.text ?? ""
        let county: String = addProjectStep3VC.countyTextField.text ?? ""
        let postalCode: String = addProjectStep3VC.postalTextField.text ?? ""
        let purchase: String = addProjectStep4VC.purchaseTextField.text ?? ""
        let build: String = addProjectStep4VC.buildTextField.text ?? ""
        let current: String = addProjectStep5VC.currentTextField.text ?? ""
        let gdv: String = addProjectStep5VC.gdvTextField.text ?? ""
        let secuityType: Int = addProjectStep6VC.firstCheckBox.isChecked ? 1 : 2
        let duration: String = addProjectStep6VC.fundDuration.text ?? ""
        let strategy: String = addProjectStep7VC.sellCheckBox.isChecked ? "Sell" : "Refinance"
        let contribute: String = addProjectStep7VC.captialCostTextField.text ?? ""
        
        if contribute == "" {
            Utils.sharedInstance.showNotice(title: "Notice", message: "Please fill all fields to share project.")
            return
        }
        
        if !contribute.isNumber {
            Utils.sharedInstance.showNotice(title: "Notice", message: "You need to fill numeric value for contribute field.")
            return
        }
        
        var projectInfo: [String: Any] = [:]
        projectInfo["title"] = title
        projectInfo["type"] = type
        projectInfo["hasFullPermission"] = hasFullPermission
        projectInfo["street"] = street
        projectInfo["city"] = city
        projectInfo["county"] = county
        projectInfo["postalCode"] = postalCode
        projectInfo["purchase"] = purchase
        projectInfo["build"] = build
        projectInfo["current"] = current
        projectInfo["gdv"] = gdv
        projectInfo["secuityType"] = secuityType
        projectInfo["duration"] = duration
        projectInfo["strategy"] = strategy
        projectInfo["contribute"] = contribute
        
        let length = 6
        let characters = "0123456789"
        let randomCharacters = (0..<length).map{_ in characters.randomElement()!}
        projectInfo["reference"] = "PR" + String(randomCharacters)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        projectInfo["added"] = formatter.string(from: Date())
        
        SVProgressHUD.show()
        FirebaseService.sharedInstance.addProject(projectInfo: projectInfo) { (projectID, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let errorMessage: String = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let successAlert = SCLAlertView(appearance: appearance)
            successAlert.addButton("OK", action: {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "developerProjectOverViewVC") as! DeveloperProjectOverViewVC
                newViewController.projectID = projectID!
                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            successAlert.showSuccess("Success", subTitle: "Your project has been successfully posted!")
        }
        
    }
    
    @IBAction func nextBtn_Click(_ sender: Any) {
        switch step {
        case 1:
            if addProjectStep1VC.projectTitleTextField.text == "" {
                Utils.sharedInstance.showNotice(title: "Notice", message: "Please fill project title to go ahead.")
                return
            }
            
            remove(asChildViewController: addProjectStep1VC)
            add(asChildViewController: addProjectStep2VC)
            prevBtn.isHidden = false
        case 2:
            if addProjectStep2VC.fundingTypeTextField.text == "" || addProjectStep2VC.fullPermissionTextField.text == "" {
                Utils.sharedInstance.showNotice(title: "Notice", message: "Please fill all fields to go ahead.")
                return
            }
            
            remove(asChildViewController: addProjectStep2VC)
            add(asChildViewController: addProjectStep3VC)
        case 3:
            if addProjectStep3VC.streetTextField.text == "" {
                Utils.sharedInstance.showNotice(title: "Notice", message: "You need to fill street field at least to go ahead.")
                return
            }
            
            remove(asChildViewController: addProjectStep3VC)
            add(asChildViewController: addProjectStep4VC)
        case 4:
            if addProjectStep4VC.purchaseTextField.text == "" || addProjectStep4VC.buildTextField.text == "" {
                Utils.sharedInstance.showNotice(title: "Notice", message: "Please fill all fields to go ahead.")
                return
            }
            
            if !addProjectStep4VC.purchaseTextField.text!.isNumber || !addProjectStep4VC.buildTextField.text!.isNumber {
                Utils.sharedInstance.showNotice(title: "Notice", message: "You should provide the numeric value for any field.")
                return
            }
            
            remove(asChildViewController: addProjectStep4VC)
            add(asChildViewController: addProjectStep5VC)
        case 5:
            if addProjectStep5VC.currentTextField.text == "" || addProjectStep5VC.gdvTextField.text == "" {
                Utils.sharedInstance.showNotice(title: "Notice", message: "Please fill all fields to go ahead.")
            }
            
            if !addProjectStep5VC.currentTextField.text!.isNumber || !addProjectStep5VC.gdvTextField.text!.isNumber {
                Utils.sharedInstance.showNotice(title: "Notice", message: "You should provide the numeric value for any field.")
                return
            }
            
            remove(asChildViewController: addProjectStep5VC)
            add(asChildViewController: addProjectStep6VC)
        case 6:
            remove(asChildViewController: addProjectStep6VC)
            add(asChildViewController: addProjectStep7VC)
            nextBtn.setTitle("Share", for: .normal)
        case 7:
            shareProject()
            return
        default:
            break
        }
        
        step = step + 1
        progressBar.setProgress(CGFloat(step)/7, animated: true)
    }
    
    @IBAction func prevBtn_Click(_ sender: Any) {
        switch step {
        case 2:
            remove(asChildViewController: addProjectStep2VC)
            add(asChildViewController: addProjectStep1VC)
            prevBtn.isHidden = true
        case 3:
            remove(asChildViewController: addProjectStep3VC)
            add(asChildViewController: addProjectStep2VC)
        case 4:
            remove(asChildViewController: addProjectStep4VC)
            add(asChildViewController: addProjectStep3VC)
        case 5:
            remove(asChildViewController: addProjectStep5VC)
            add(asChildViewController: addProjectStep4VC)
        case 6:
            remove(asChildViewController: addProjectStep6VC)
            add(asChildViewController: addProjectStep5VC)
        case 7:
            remove(asChildViewController: addProjectStep7VC)
            add(asChildViewController: addProjectStep6VC)
            nextBtn.setTitle("Next", for: .normal)
        default:
            break
        }
        step = step - 1
        progressBar.setProgress(CGFloat(step)/7, animated: true)
    }
}
