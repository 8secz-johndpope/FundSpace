//
//  LeaderInBoxVC.swift
//  FundSpace
//
//  Created by admin on 9/16/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell
import SVProgressHUD

class LeaderInBoxVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var channelTableView: UITableView!
    
    var channels: Array<[String: Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadData()
    }
    
    
    func loadData() {
        SVProgressHUD.show()
        FirebaseService.sharedInstance.getChannels() { (channels, error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let errMsg = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errMsg)
                return
            } else {
                self.channels = channels!
                self.channelTableView.reloadData()
            }
        }
    }
    
    func findChannel(id: String, completion: @escaping (Channel?) -> Void) {
        FirebaseService.sharedInstance.findChannel(id: id) { (queryDocument, error) in
            if let error = error {
                let errMsg = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errMsg)
                completion(nil)
            } else if queryDocument == nil {
                Utils.sharedInstance.showError(title: "Error", message: "We can't find the correspond channel.")
                completion(nil)
            } else {
                completion(Channel(document: queryDocument!)!)
            }
        }
    }
    
    // MARK: - TableView Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if channels.count == 0 {
            channelTableView.setEmptyMessage("No data to display")
        } else {
            channelTableView.restore()
        }
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxTableViewCell", for: indexPath) as! InboxTableViewCell
        
        let data: [String: Any] = channels[indexPath.row]
        
        FirebaseService.sharedInstance.getChannelDetail(channel: data) { (channelInfo, error) in
            if let error = error {
                let errorMessage = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            
            cell.userInfo = channelInfo
            
            let profileImagePath: String = channelInfo!["profile_pic"] != nil ? channelInfo!["profile_pic"] as! String : ""
            cell.nameLabel.text = channelInfo!["name"] as? String ?? ""
            let message: String = data["message"] as? String ?? ""
            
            cell.messageLabel.text = message == "" ? "Sent new image" : message
            
            cell.selectionStyle = .none
            
            cell.profileImageView?.layer.cornerRadius = (cell.profileImageView?.frame.width)! / 2.0
            cell.profileImageView?.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
            cell.profileImageView?.layer.borderWidth = 1
            
            
            if (profileImagePath == "") {
                cell.profileImageView.image = UIImage(named: "default_avatar.png")
            } else {
                FirebaseService.sharedInstance.downloadImage(path: profileImagePath) { (imageData, error) in
                    if let error = error {
                        let errorMessage: String = error.localizedDescription
                        Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                        cell.profileImageView.image = UIImage(named: "default_avatar.png")
                    } else {
                        let image = UIImage(data: imageData!)
                        cell.profileImageView.image = image
                    }
                }
            }
        }
        
        cell.rightButtons = [
            MGSwipeButton(title: "Delete", backgroundColor: UIColor(red: 0, green: 0.49, blue: 1, alpha: 1), callback: { (cell) -> Bool in
                return true
            }),
            MGSwipeButton(title: "Archive", backgroundColor: UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), callback: { (cell) -> Bool in
                return true
            })
        ]
        
        cell.rightSwipeSettings.transition = .rotate3D
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! InboxTableViewCell
        let channelData: [String: Any] = channels[indexPath.row]
        let userData: [String: Any] = cell.userInfo
        
        let receiverID: String = channelData["receiver"] as? String ?? ""
        let senderID: String = channelData["sender"] as? String ?? ""
        let currentUserID: String = Auth.auth().currentUser!.uid
        
        let id: String = currentUserID == receiverID ? senderID : receiverID
        
        findChannel(id: id) { (channel) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
            newViewController.userName = userData["name"] != nil ? userData["name"] as! String : "No Name"
            newViewController.userProfileImage = cell.profileImageView.image!
            newViewController.channel = channel
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }

}
