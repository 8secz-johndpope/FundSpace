//
//  DeveloperEditProfileViewController.swift
//  FundSpace
//
//  Created by admin on 5/8/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import StepProgressBar
import SnapKit

class DeveloperEditProfileViewController: UIViewController {

    @IBOutlet weak var stepBar: StepProgressBar!
    @IBOutlet weak var basicContainerView: UIView!
    @IBOutlet weak var companyContainerView: UIView!
    @IBOutlet weak var bioContainerView: UIView!
    
    var basicVC: BasicViewViewController!
    var companyVC: CompanyViewController!
    var bioVC: BioViewController!
    
    var index: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func createBarItem(imageName: String, target: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.addTarget(self, action: target, for: UIControl.Event.touchUpInside)
        
        let btnItem = UIBarButtonItem(customView: btn)
        let currWidth = btnItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = btnItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        
        return btnItem
    }
    

    func initUI() {
        navigationItem.title = "Basic"
        
        self.navigationItem.leftBarButtonItem = self.createBarItem(imageName: "back", target: #selector(goBack))
        self.navigationItem.rightBarButtonItem = self.createBarItem(imageName: "next", target: #selector(goNext))
        
        index = 1
    }
    
    func update() {
        
    }
    
    @objc func goBack(){
        switch index {
        case 1:
            self.navigationController?.popViewController(animated: true)
            break
        case 2:
            navigationItem.title = "Basic"
            self.basicContainerView.alpha = 1.0
            self.companyContainerView.alpha = 0.0
            self.bioContainerView.alpha = 0.0
            index = index - 1
            stepBar.previous()
            break
        case 3:
            navigationItem.title = "Company"
            self.basicContainerView.alpha = 0.0
            self.companyContainerView.alpha = 1.0
            self.bioContainerView.alpha = 0.0
            index = index - 1
            stepBar.previous()
            break
        default:
            break
        }
    }
    
    @objc func goNext(){
        switch index {
        case 1:
            navigationItem.title = "Company"
            self.basicContainerView.alpha = 0.0
            self.companyContainerView.alpha = 1.0
            self.bioContainerView.alpha = 0.0
            index = index + 1
            stepBar.next()
            break
        case 2:
            navigationItem.title = "Bio"
            self.basicContainerView.alpha = 0.0
            self.companyContainerView.alpha = 0.0
            self.bioContainerView.alpha = 1.0
            index = index + 1
            stepBar.next()
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
            
        case let viewController1 as BasicViewViewController:
            self.basicVC = viewController1
            
        case let viewController2 as CompanyViewController:
            self.companyVC = viewController2
            
        case let viewController3 as BioViewController:
            self.bioVC = viewController3
            
        default:
            break
        }
    }
    
}
