//
//  LeaderCurrentProjectsVC.swift
//  FundSpace
//
//  Created by admin on 9/13/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LeaderCurrentProjectsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var projectsTableView: UITableView!
    var projects: Array<[String: Any]> = []
    let currentUserID: String = Auth.auth().currentUser!.uid
    var user_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }
    
    func loadData() {
        SVProgressHUD.show()
        FirebaseService.sharedInstance.getProjectsByUserID(user_id) {(projects, error) in
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
    
    func wasBookMarked(user_list: Array<String>?) -> Bool {
        if user_list == nil {
            return false
        }
        return user_list!.contains(currentUserID)
    }
    
    @objc func bookmarkBtnClick(sender: UIButton) {
        let tag = sender.tag
        let data = projects[tag]
        var bookmarks: Array<String> = data["bookmark"] as? Array<String> ?? []
        let currentUserID: String = Auth.auth().currentUser!.uid
        if (wasBookMarked(user_list: data["bookmark"] as? Array<String>)) {
            let index = bookmarks.firstIndex(of: currentUserID)
            bookmarks.remove(at: index!)
        } else {
            bookmarks.append(currentUserID)
        }
        
        FirebaseService.sharedInstance.updateProject(id: data["id"] as! String, projectInfo: ["bookmark": bookmarks]) { (error) in
            if let error = error {
                let errorMessage = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            
            if (self.wasBookMarked(user_list: data["bookmark"] as? Array<String>)) {
                sender.setImage(UIImage(named: "default_bookmark"), for: .normal)
            } else {
                sender.setImage(UIImage(named: "bookmark"), for: .normal)
            }
            
            self.projects[tag]["bookmark"] = bookmarks
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderProjectTableViewCell", for: indexPath) as! LeaderProjectTableViewCell
        
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
        
        if (wasBookMarked(user_list: data["bookmark"] as? Array<String>)) {
            cell.bookmarkBtn.setImage(UIImage(named: "bookmark"), for: .normal)
        } else {
            cell.bookmarkBtn.setImage(UIImage(named: "default_bookmark"), for: .normal)
        }
        
        cell.bookmarkBtn.addTarget(self, action: #selector(self.bookmarkBtnClick(sender:)), for: .touchUpInside)
        
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
