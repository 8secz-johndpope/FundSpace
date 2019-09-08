//
//  LeaderSearchVC.swift
//  FundSpace
//
//  Created by admin on 9/9/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class LeaderSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addedDateView: UIView!
    @IBOutlet weak var addedDateTextField: UITextField!
    @IBOutlet weak var fundingRequiredView: UIView!
    @IBOutlet weak var fundingRequiredTextField: UITextField!
    @IBOutlet weak var developerExperienceView: UIView!
    @IBOutlet weak var developerExperienceTextField: UITextField!
    @IBOutlet weak var fundingTypeView: UIView!
    @IBOutlet weak var fundingTypeTextField: UITextField!
    @IBOutlet weak var advancedView: UIView!
    @IBOutlet weak var advancedFilterBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    @IBOutlet weak var projectsTableView: UITableView!
    
    var projects: Array<[String: Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initUI()
    }
    
    func initUI() {
        searchTextField.setLeftIcon(UIImage(named: "search_icon")!)
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 4
        searchTextField.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        
        let borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        addedDateView.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 0.5)
        fundingRequiredView.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 0.5)
        developerExperienceView.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 0.5)
        fundingTypeView.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 0.5)
        
        searchBtn.layer.cornerRadius = 4
        resetBtn.layer.cornerRadius = 4
        resetBtn.layer.borderWidth = 1
        resetBtn.layer.borderColor = UIColor(red: 0.57, green: 0.57, blue: 0.57, alpha: 1).cgColor
    }
    
    @IBAction func advancedFilterBtn_Click(_ sender: Any) {
    }
    
    @IBAction func searchBtn_Click(_ sender: Any) {
    }
    
    @IBAction func resetBtn_Click(_ sender: Any) {
    }
    
    // MARK: - TableView Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if projects.count == 0 {
            projectsTableView.setEmptyMessage("No data to display")
        } else {
            projectsTableView.restore()
        }
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectTableViewCell", for: indexPath) as! ProjectTableViewCell
        
        let data: [String: Any] = projects[indexPath.row]
        cell.projectCostLabel.text = data["contribute"] as? String
        cell.projectTypeLabel.text = data["type"] as? String
        cell.projectTitleLabel.text = data["title"] as? String
        cell.projectAddressLabel.text = data["street"] as? String
        
        if (data["hasFullPermission"] as! Bool == true) {
            cell.projectPermissionLabel.text = "Total funding required."
        } else {
            cell.projectPermissionLabel.text = ""
        }
        
        let units: Int = Int(data["units"] as! String) ?? 0
        
        if units == 0 {
            cell.projectBedroomsView.isHidden = true
        } else {
            cell.projectBedroomsView.isHidden = false
            cell.projectBedroomsLabel.text = "x"+String(units)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: [String: Any] = projects[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "developerProjectOverViewVC") as! DeveloperProjectOverViewVC
        newViewController.projectID = data["id"] as! String
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
}
