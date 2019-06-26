//
//  DeveloperProfileViewController.swift
//  FundSpace
//
//  Created by admin on 4/30/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class DeveloperProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var personalView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var basicView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var shareholderLabel: UILabel!
    @IBOutlet weak var otherShareholderLabel: UILabel!
    @IBOutlet weak var companyNoLabel: UILabel!
    @IBOutlet weak var projectsView: UIView!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingProgressBar: UIProgressView!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var supportingButton: UIButton!
    @IBOutlet weak var projectCountView: UIView!
    @IBOutlet weak var projectCountLabel: UILabel!
    @IBOutlet weak var experienceView: UIView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
    }
    
    func initUI() {
        profileImage.layer.cornerRadius = 75
        profileImage.layer.borderWidth = 1.5
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        addProjectButton.layer.cornerRadius = 6
        
        personalView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 0.7)
        projectCountView.setBorder(radius: 6, color: .lightGray)
        experienceView.setBorder(radius: 6, color: .lightGray)
        bioView.setBorder(radius: 6, color: .lightGray)
        basicView.setBorder(radius: 6, color: .lightGray)
        projectsView.setBorder(radius: 6, color: .lightGray)
        ratingView.setBorder(radius: 6, color: .lightGray)
        chartView.setBorder(radius: 6, color: .lightGray)
        
        supportingButton.setBorder(radius: 15, color: .lightGray)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(goToEdit))
    }
    
    @objc func goToEdit() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "developerEditProfileVC") as! DeveloperEditProfileViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func linkedinBtn_Click(_ sender: Any) {
    }
    
    @IBAction func addProjectBtn_Click(_ sender: Any) {
    }
    
    @IBAction func supportingBtn_Click(_ sender: Any) {
    }
    
}
