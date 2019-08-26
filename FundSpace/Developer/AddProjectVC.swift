//
//  AddProjectVC.swift
//  FundSpace
//
//  Created by admin on 8/25/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import M13ProgressSuite

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
        initUI()
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
        
    }
    
    @IBAction func nextBtn_Click(_ sender: Any) {
        switch step {
        case 1:
            remove(asChildViewController: addProjectStep1VC)
            add(asChildViewController: addProjectStep2VC)
            prevBtn.isHidden = false
        case 2:
            remove(asChildViewController: addProjectStep2VC)
            add(asChildViewController: addProjectStep3VC)
        case 3:
            remove(asChildViewController: addProjectStep3VC)
            add(asChildViewController: addProjectStep4VC)
        case 4:
            remove(asChildViewController: addProjectStep4VC)
            add(asChildViewController: addProjectStep5VC)
        case 5:
            remove(asChildViewController: addProjectStep5VC)
            add(asChildViewController: addProjectStep6VC)
        case 6:
            remove(asChildViewController: addProjectStep6VC)
            add(asChildViewController: addProjectStep7VC)
            nextBtn.setTitle("Share", for: .normal)
        case 7:
            shareProject()
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
