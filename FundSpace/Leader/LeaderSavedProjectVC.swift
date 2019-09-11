//
//  LeaderSavedProjectVC.swift
//  FundSpace
//
//  Created by admin on 9/12/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SVProgressHUD

class LeaderSavedProjectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var projectsTableView: UITableView!
    var projects: Array<[String: Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func loadData() {
        SVProgressHUD.show()
        FirebaseService.sharedInstance.getBookmarkProjects { (projects, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let errMsg = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errMsg)
                return
            } else {
                self.projects = projects!
                self.projectsTableView.reloadData()
            }
        }
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
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: [String: Any] = projects[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "leaderProjectOverViewVC") as! LeaderProjectOverViewVC
        newViewController.projectID = data["id"] as! String
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
