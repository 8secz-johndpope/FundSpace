//
//  DeveloperNotificationVC.swift
//  FundSpace
//
//  Created by admin on 8/20/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SVProgressHUD

class DeveloperNotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var notificationTableView: UITableView!
    var notifications: Array<[String: Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        loadData()
    }
    
    func loadData() {
        SVProgressHUD.show()
        FirebaseService.sharedInstance.getNotificationsByID("") { (notifications, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let errMsg = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errMsg)
                return
            } else {
                self.notifications = notifications!
                self.notificationTableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.count == 0 {
            notificationTableView.setEmptyMessage("No data to display")
        } else {
            notificationTableView.restore()
        }
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        let data: [String: Any] = notifications[indexPath.row]
        
        cell.nameLabel.text = data["name"] as? String ?? ""
        switch data["type"] as? String {
        case "save":
            cell.messageLabel.text = "Save your project"
        case "message":
            cell.messageLabel.text = "Sent you a message"
        case "view":
            cell.messageLabel.text = "Viewed your project"
        case "terms":
            cell.messageLabel.text = "Sent you funding items"
        default:
            break
        }
        
        FirebaseService.sharedInstance.downloadImage(path: data["image"] as! String) { (imageData, error) in
            if let error = error {
                let errorMessage: String = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                cell.profileImageView.image = UIImage(named: "default_avatar.png")
            } else {
                let image = UIImage(data: imageData!)
                cell.profileImageView.image = image
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let data: [String: Any] = notifications[indexPath.row]
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "developerProjectOverViewVC") as! DeveloperProjectOverViewVC
//        newViewController.projectID = data["id"] as! String
//        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
}
