//
//  AddProjectViewController.swift
//  FundSpace
//
//  Created by adnin on 6/25/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import StepProgressBar

class AddProjectViewController: UIViewController {

    @IBOutlet weak var projectContainerView: UIView!
    @IBOutlet weak var costingsContainerView: UIView!
    @IBOutlet weak var otherContainerView: UIView!
    @IBOutlet weak var stepProgressBar: StepProgressBar!
    
    var projectVC: ProjectViewController!
    var costingsVC: CostingsViewController!
    var otherVC: OtherViewController!
    
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
        navigationItem.title = "Project"
        
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
            navigationItem.title = "Project"
            self.projectContainerView.alpha = 1.0
            self.costingsContainerView.alpha = 0.0
            self.otherContainerView.alpha = 0.0
            index = index - 1
            stepProgressBar.previous()
            break
        case 3:
            navigationItem.title = "Costings"
            self.projectContainerView.alpha = 0.0
            self.costingsContainerView.alpha = 1.0
            self.otherContainerView.alpha = 0.0
            index = index - 1
            stepProgressBar.previous()
            break
        default:
            break
        }
    }
    
    @objc func goNext(){
        switch index {
        case 1:
            navigationItem.title = "Costings"
            self.projectContainerView.alpha = 0.0
            self.costingsContainerView.alpha = 1.0
            self.otherContainerView.alpha = 0.0
            index = index + 1
            stepProgressBar.next()
            break
        case 2:
            navigationItem.title = "Other"
            self.projectContainerView.alpha = 0.0
            self.costingsContainerView.alpha = 0.0
            self.otherContainerView.alpha = 1.0
            index = index + 1
            stepProgressBar.next()
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
            
        case let viewController1 as ProjectViewController:
            self.projectVC = viewController1
            
        case let viewController2 as CostingsViewController:
            self.costingsVC = viewController2
            
        case let viewController3 as OtherViewController:
            self.otherVC = viewController3
            
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
