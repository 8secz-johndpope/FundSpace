//
//  LeaderProfileVC.swift
//  FundSpace
//
//  Created by admin on 8/25/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SVProgressHUD

class LeaderProfileVC: UIViewController {
    @IBOutlet weak var rightNavBarBtn: UIBarButtonItem!
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var policyBtn: UIButton!
    
    var isSave: Bool = false
    var imagePicker: ImagePicker!
    var userInfo: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        initUI()
        makeEditable(false)
        fetchInitData()
    }
    
    func initUI() {
        basicInfoView.makeRoundShadowView()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageBtn.setImage(UIImage(named: "circle_border"), for: .normal)
        profileImageBtn.setImage(UIImage(named: "circle_border"), for: .disabled)
        
        bioView.makeRoundShadowView()
        
        logOutBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        logOutBtn.layer.borderWidth = 1
        logOutBtn.layer.cornerRadius = 4
        
        policyBtn.underline()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func makeEditable(_ flag: Bool) {
        profileImageBtn.isEnabled = flag
        bioTextView.isEditable = flag
    }
    
    func fetchInitData() {
        userInfo = UserDefaults.standard.value(forKey: "userInfo") as? [String: Any] ?? [:]
        
        let name: String = userInfo["name"] != nil ? userInfo["name"] as! String : "No Name"
        let companyName = userInfo["companyName"] != nil ? userInfo["companyName"] as! String : "No Company"
        let position = userInfo["position"] != nil ? userInfo["position"] as! String : "No Position"
        let lenderBio: String = userInfo["lenderBio"] != nil ? userInfo["lenderBio"] as! String : ""
        
        
        nameLabel.text = name
        companyLabel.text = companyName
        locationLabel.text = position
        
        bioTextView.text = lenderBio
        
        let profileImagePath: String = userInfo["profile_pic"] != nil ? userInfo["profile_pic"] as! String : ""
        
        if (profileImagePath == "") {
            self.profileImageView.image = UIImage(named: "default_avatar")
        } else {
            SVProgressHUD.show()
            FirebaseService.sharedInstance.downloadImage(path: profileImagePath) { (data, error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    let errorMessage: String = error.localizedDescription
                    Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                    self.profileImageView.image = UIImage(named: "default_avatar")
                } else {
                    let image = UIImage(data: data!)
                    self.profileImageView.image = image
                }
            }
        }
    }
    
    func updateUserInfo() {
        let profile_image = profileImageView.image ?? nil
        let imageData = profile_image?.pngData() ?? nil
        
        let lenderBio: String = bioTextView.text ?? ""
        
        userInfo["lenderBio"] = lenderBio
        
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
                
                self.rightNavBarBtn.title = "Edit"
                self.profileImageBtn.setImage(UIImage(named: "circle_border"), for: .normal)
                
                self.makeEditable(false)
            })
        }
    }
    
    @IBAction func profileImageBtn_Click(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func logOutBtn_Click(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "userInfo")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LogInVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func termsBtn_Click(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "termsVC") as! TermsVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func policyBtn_Click(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "privacyVC") as! PrivacyVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func rightNavBarBtn_Click(_ sender: Any) {
        if (isSave) {
            updateUserInfo()
        } else {
            makeEditable(true)
            profileImageBtn.setImage(UIImage(named: "avatar_border"), for: .normal)
            rightNavBarBtn.title = "Save"
        }
        isSave = !isSave
    }
    
    @IBAction func leftNavBarBtn_Click(_ sender: Any) {
    }
}

extension LeaderProfileVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
    }
}
