//
//  GetStartedLeaderVCViewController.swift
//  FundSpace
//
//  Created by admin on 8/21/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class GetStartedLeaderVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var companyNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var companyPositionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var createProfileBtn: UIButton!
    
    var imagePicker: ImagePicker!
    
    var userInfo: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initUI()
        getUserInfo()
    }
    
    func initUI() {
        createProfileBtn.layer.cornerRadius = 6
        
        nameTextField.font = UIFont(name: "OpenSans", size: 15)
        companyNameTextField.font = UIFont(name: "OpenSans", size: 15)
        companyPositionTextField.font = UIFont(name: "OpenSans", size: 15)
        phoneTextField.font = UIFont(name: "OpenSans", size: 15)
        
        profileImageView.layer.cornerRadius = 60
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func getUserInfo() {
        userInfo = UserDefaults.standard.value(forKey: "userInfo") as! [String : Any]
        
        nameTextField.text = (userInfo["name"] as! String)
    }
    

    @IBAction func profileImageBtn_Click(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func createProfileBtn_Click(_ sender: UIButton) {
        let name: String = nameTextField.text ?? ""
        let companyName: String = companyNameTextField.text ?? ""
        let position: String = companyPositionTextField.text ?? ""
        let phone: String = phoneTextField.text ?? ""
        
        let profile_image = profileImageView.image ?? nil
        let imageData = profile_image?.pngData() ?? nil
        
        userInfo["name"] = name
        userInfo["companyName"] = companyName
        userInfo["position"] = position
        userInfo["phone"] = phone
        userInfo["has_basic"] = true
        
        SVProgressHUD.show()

        FirebaseService.sharedInstance.uploadImage(imageData: imageData) { (result, error) in
            if (error != nil) {
                SVProgressHUD.dismiss()
                let errorMessage: String = error?.localizedDescription ?? ""
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            
            FirebaseService.sharedInstance.storeUserInfo(id: result!, userInfo: self.userInfo, completion: { (error) in
                SVProgressHUD.dismiss()
                if (error != nil) {
                    let errorMessage: String = error?.localizedDescription ?? ""
                    Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                    return
                }
                
                UserDefaults.standard.set(self.userInfo, forKey: "userInfo")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "leaderTabBarController") as! LeaderTabBarController
                self.present(newViewController, animated: true, completion: nil)
            })
        }
    }
    
}

extension GetStartedLeaderVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
        self.profileImageBtn.setImage(UIImage(named: "avatar_border.png"), for: .normal)
    }
}
