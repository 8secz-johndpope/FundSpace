//
//  DeveloperProfileVC.swift
//  FundSpace
//
//  Created by admin on 8/20/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import M13ProgressSuite
import Charts
import SVProgressHUD

class DeveloperProfileVC: UIViewController {
    @IBOutlet weak var rightNavigationBarBtn: UIBarButtonItem!
    @IBOutlet weak var leftNavigationBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var addProjectBtn: UIButton!
    
    @IBOutlet weak var developerInfoView: UIView!
    @IBOutlet weak var experienceView: UIView!
    @IBOutlet weak var experienceTextField: UITextField!
    @IBOutlet weak var birthView: UIView!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var occupationView: UIView!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var employmentStatusView: UIView!
    @IBOutlet weak var employmentStatusTextField: UITextField!
    @IBOutlet weak var annualIncomeView: UIView!
    @IBOutlet weak var annualIncomeTextField: UITextField!
    @IBOutlet weak var nationalityView: UIView!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var residentialStatusView: UIView!
    @IBOutlet weak var residentialStatusTextField: UITextField!
    @IBOutlet weak var residentialAddressView: UIView!
    @IBOutlet weak var residentialAddressTextField: UITextField!
    @IBOutlet weak var residentSinceTextField: UITextField!
    
    @IBOutlet weak var companyInfoView: UIView!
    @IBOutlet weak var companyNameView: UIView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var countryIncorporationView: UIView!
    @IBOutlet weak var countryIncorporationTextField: UITextField!
    @IBOutlet weak var companyRegisterNumberView: UIView!
    @IBOutlet weak var companyRegisterNumberTextField: UITextField!
    @IBOutlet weak var companyRegisteredAddressView: UIView!
    @IBOutlet weak var companyRegisteredAddressTextField: UITextField!
    @IBOutlet weak var shareholdersTextField: UITextField!
    
    @IBOutlet weak var projectView: UIView!
    @IBOutlet weak var projectsDropDown: iOSDropDown!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var projectAddressView: UIView!
    @IBOutlet weak var projectAddressTextField: UITextField!
    @IBOutlet weak var projectPurchaseView: UIView!
    @IBOutlet weak var projectPurchaseTextField: UITextField!
    @IBOutlet weak var projectBuildView: UIView!
    @IBOutlet weak var projectBuildTextField: UITextField!
    @IBOutlet weak var projectSaleView: UIView!
    @IBOutlet weak var projectSaleTextField: UITextField!
    @IBOutlet weak var projectCompleteDateView: UIView!
    @IBOutlet weak var projectCompleteDateTextField: UITextField!
    @IBOutlet weak var projectProfitView: UIView!
    @IBOutlet weak var projectProfitTextField: UITextField!
    @IBOutlet weak var projectLenderView: UIView!
    @IBOutlet weak var projectLenderTextField: UITextField!
    @IBOutlet weak var projectSaveBtn: UIButton!
    
    @IBOutlet weak var creditPositionView: UIView!
    @IBOutlet weak var creditPositionProgressBar: M13ProgressViewBar!
    
    @IBOutlet weak var assetsView: UIView!
    @IBOutlet weak var assetsChatView: BarChartView!
    
    @IBOutlet weak var uploadDocumentBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var isSave: Bool = false
    var imagePicker: ImagePicker!
    var userInfo: [String: Any] = [:]
    var prevProjects: Array<[String: Any]> = []
    var selectedIndex: Int = 0
    var isNewPrevProject: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        initGesture()
        makeEditable(false)
        fetchInitData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initGesture() {
        let creditPositionGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnCreditPosition))
        creditPositionView.addGestureRecognizer(creditPositionGesture)
    }
    
    func initUI() {
        let bordorColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        basicInfoView.makeRoundShadowView()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageBtn.setImage(UIImage(named: "circle_border.png"), for: .normal)
        
        addProjectBtn.layer.cornerRadius = 4
        
        developerInfoView.makeRoundShadowView()
        experienceView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        birthView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        occupationView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        employmentStatusView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        annualIncomeView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        nationalityView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        residentialStatusView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        residentialAddressView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        
        
        companyInfoView.makeRoundShadowView()
        companyNameView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        countryIncorporationView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        companyRegisterNumberView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        companyRegisteredAddressView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        
        projectView.makeRoundShadowView()
        projectsDropDown.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        projectsDropDown.borderWidth = 1
        projectsDropDown.cornerRadius = 6
        projectsDropDown.font = UIFont(name: "OpenSans", size: 12)
        projectsDropDown.setLeftPaddingPoints(10)
        projectsDropDown.isSearchEnable = false
        projectsDropDown.selectedRowColor = UIColor.lightGray
        
        projectsDropDown.didSelect { (selectedText, index, id) in
            self.configureProjectView(index: index)
            self.selectedIndex = index
        }
        
        projectAddressView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        projectPurchaseView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        projectBuildView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        projectSaleView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        projectCompleteDateView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        projectProfitView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        projectLenderView.addBottomBorder(color: bordorColor, margins: 0, borderLineSize: 0.5)
        projectSaveBtn.layer.cornerRadius = 4
        
        creditPositionView.makeRoundShadowView()
        creditPositionProgressBar.setProgress(0.75, animated: true)
        creditPositionProgressBar.showPercentage = false
        
        assetsView.makeRoundShadowView()
        
        uploadDocumentBtn.layer.cornerRadius = 4
        
        logoutBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.cornerRadius = 4
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
    
    @objc func handleTapOnCreditPosition() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "creditPositionVC") as! CreditPositionVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func makeEditable(_ flag: Bool) {
        profileImageBtn.isEnabled = flag
        
        experienceTextField.isEnabled = flag
        birthTextField.isEnabled = flag
        occupationTextField.isEnabled = flag
        employmentStatusTextField.isEnabled = flag
        annualIncomeTextField.isEnabled = flag
        nationalityTextField.isEnabled = flag
        residentialStatusTextField.isEnabled = flag
        residentialAddressTextField.isEnabled = flag
        residentSinceTextField.isEnabled = flag
        
        companyNameTextField.isEnabled = flag
        countryIncorporationTextField.isEnabled = flag
        companyRegisterNumberTextField.isEnabled = flag
        companyRegisteredAddressTextField.isEnabled = flag
        shareholdersTextField.isEnabled = flag
        
        projectNameTextField.isEnabled = flag
        projectAddressTextField.isEnabled = flag
        projectPurchaseTextField.isEnabled = flag
        projectBuildTextField.isEnabled = flag
        projectSaleTextField.isEnabled = flag
        projectCompleteDateTextField.isEnabled = flag
        projectProfitTextField.isEnabled = flag
        projectLenderTextField.isEnabled = flag
        projectSaveBtn.isEnabled = flag
    }
    
    func getOptionArray() -> Array<String> {
        var options: Array<String> = []
        for prevProject in prevProjects {
            options.append(prevProject["name"] as! String)
        }
        
        options.append("Add new previous project")
        return options
    }
    
    func configureProjectView(index: Int) {
        if index == getOptionArray().count - 1 {
            projectNameTextField.text = ""
            projectAddressTextField.text = ""
            projectPurchaseTextField.text = ""
            projectBuildTextField.text = ""
            projectSaleTextField.text = ""
            projectCompleteDateTextField.text = ""
            projectProfitTextField.text = ""
            projectLenderTextField.text = ""
            
            isNewPrevProject = true
        } else {
            let prevProject = prevProjects[index]
            projectNameTextField.text = prevProject["name"] as? String ?? ""
            projectAddressTextField.text = prevProject["address"] as? String ?? ""
            projectPurchaseTextField.text = prevProject["purchase"] as? String ?? ""
            projectBuildTextField.text = prevProject["build"] as? String ?? ""
            projectSaleTextField.text = prevProject["sale"] as? String ?? ""
            projectCompleteDateTextField.text = prevProject["complete"] as? String ?? ""
            projectProfitTextField.text = prevProject["profit"] as? String ?? ""
            projectLenderTextField.text = prevProject["lender"] as? String ?? ""
            
            isNewPrevProject = false
        }
    }
    
    func initDropDown() {
        let optionArray = getOptionArray()
        
        projectsDropDown.optionArray = optionArray
        
        // Select first element by default.
        let selectedText = optionArray[0]
        projectsDropDown.text = selectedText
        projectsDropDown.select(selectedText)
        configureProjectView(index: 0)
    }
    
    func fetchPrevProjects() {
        FirebaseService.sharedInstance.fetchPreviousProjects(completion: { (prevProjects, error) in
            SVProgressHUD.dismiss()
            
            if let error = error {
                let errorMessage: String = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            } else {
                self.prevProjects = prevProjects!
                self.initDropDown()
            }
        })
    }
    
    func fetchInitData() {
        userInfo = UserDefaults.standard.value(forKey: "userInfo") as? [String: Any] ?? [:]
        
        let name: String = userInfo["name"] != nil ? userInfo["name"] as! String : "No Name"
        let companyName = userInfo["companyName"] != nil ? userInfo["companyName"] as! String : "No Company"
        let location = userInfo["location"] != nil ? userInfo["location"] as! String : "No Location"
        let developerExperience: String = userInfo["developerExperience"] != nil ? userInfo["developerExperience"] as! String : ""
        let birthDate: String = userInfo["birthDate"] != nil ? userInfo["birthDate"] as! String : ""
        let occupation: String = userInfo["occupation"] != nil ? userInfo["occupation"] as! String : ""
        let employmentStatus: String = userInfo["employmentStatus"] != nil ? userInfo["employmentStatus"] as! String : ""
        let annualIncome: String = userInfo["annualIncome"] != nil ? userInfo["annualIncome"] as! String : ""
        let nationality: String = userInfo["nationality"] != nil ? userInfo["nationality"] as! String : ""
        let residentialStatus: String = userInfo["residentialStatus"] != nil ? userInfo["residentialStatus"] as! String : ""
        let residentialAddress: String = userInfo["residentialAddress"] != nil ? userInfo["residentialAddress"] as! String : ""
        let residentSince: String = userInfo["residentSince"] != nil ? userInfo["residentSince"] as! String : ""
        
        let countryIncorporation: String = userInfo["countryIncorporation"] != nil ? userInfo["countryIncorporation"] as! String : ""
        let companyRegisterNumber: String = userInfo["companyRegisterNumber"] != nil ? userInfo["companyRegisterNumber"] as! String : ""
        let companyRegisteredAddress: String = userInfo["companyRegisteredAddress"] != nil ? userInfo["companyRegisteredAddress"] as! String : ""
        let shareHolders: String = userInfo["shareHolders"] != nil ? userInfo["shareHolders"] as! String : ""
        
        nameLabel.text = name
        companyLabel.text = companyName
        locationLabel.text = location
        
        experienceTextField.text = developerExperience
        birthTextField.text = birthDate
        occupationTextField.text = occupation
        employmentStatusTextField.text = employmentStatus
        annualIncomeTextField.text = annualIncome
        nationalityTextField.text = nationality
        residentialStatusTextField.text = residentialStatus
        residentialAddressTextField.text = residentialAddress
        residentSinceTextField.text = residentSince
        
        companyNameTextField.text = companyName
        countryIncorporationTextField.text = countryIncorporation
        companyRegisterNumberTextField.text = companyRegisterNumber
        companyRegisteredAddressTextField.text = companyRegisteredAddress
        shareholdersTextField.text = shareHolders
        
        
        let profileImagePath: String = userInfo["profile_pic"] != nil ? userInfo["profile_pic"] as! String : ""
        
        if (profileImagePath == "") {
            self.profileImageView.image = UIImage(named: "default_avatar.png")
        } else {
            SVProgressHUD.show()
            FirebaseService.sharedInstance.downloadImage(path: profileImagePath) { (data, error) in
                if let error = error {
                    let errorMessage: String = error.localizedDescription
                    Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                    self.profileImageView.image = UIImage(named: "default_avatar.png")
                } else {
                    let image = UIImage(data: data!)
                    self.profileImageView.image = image
                }
                
                self.fetchPrevProjects()
            }
        }
    }
    
    func updateUserInfo() {
        let profile_image = profileImageView.image ?? nil
        let imageData = profile_image?.pngData() ?? nil
        
        let developerExperience: String = experienceTextField.text ?? ""
        let birthDate: String = birthTextField.text ?? ""
        let occupation: String = occupationTextField.text ?? ""
        let employmentStatus: String = employmentStatusTextField.text ?? ""
        let annualIncome: String = annualIncomeTextField.text ?? ""
        let nationality: String = nationalityTextField.text ?? ""
        let residentialStatus: String = residentialStatusTextField.text ?? ""
        let residentialAddress: String = residentialAddressTextField.text ?? ""
        let residentSince: String = residentSinceTextField.text ?? ""
        
        let companyName: String = companyNameTextField.text ?? ""
        let countryIncorporation: String = countryIncorporationTextField.text ?? ""
        let companyRegisterNumber: String = companyRegisterNumberTextField.text ?? ""
        let companyRegisteredAddress: String = companyRegisteredAddressTextField.text ?? ""
        let shareHolders: String = shareholdersTextField.text ?? ""
        
        userInfo["developerExperience"] = developerExperience
        userInfo["birthDate"] = birthDate
        userInfo["occupation"] = occupation
        userInfo["employmentStatus"] = employmentStatus
        userInfo["annualIncome"] = annualIncome
        userInfo["nationality"] = nationality
        userInfo["residentialStatus"] = residentialStatus
        userInfo["residentialAddress"] = residentialAddress
        userInfo["residentSince"] = residentSince
        userInfo["companyName"] = companyName
        userInfo["countryIncorporation"] = countryIncorporation
        userInfo["companyRegisterNumber"] = companyRegisterNumber
        userInfo["companyRegisteredAddress"] = companyRegisteredAddress
        userInfo["shareHolders"] = shareHolders
        
        
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
                
                self.rightNavigationBarBtn.title = "Edit"
                self.profileImageBtn.setImage(UIImage(named: "circle_border.png"), for: .normal)
                
                self.makeEditable(false)
            })
        }
    }
    
    @IBAction func rightNavigationBarBtn_Click(_ sender: Any) {
        if (isSave) {
            updateUserInfo()
        } else {
            makeEditable(true)
            profileImageBtn.setImage(UIImage(named: "avatar_border.png"), for: .normal)
            rightNavigationBarBtn.title = "Save"
        }
        isSave = !isSave
    }
    
    @IBAction func leftNavigationBarBtn_Click(_ sender: Any) {
    }
    
    @IBAction func profileImageBtn_Click(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func addProjectBtn_Click(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "addProjectVC") as! AddProjectVC
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func uploadDocumentBtn_Click(_ sender: Any) {
    }
    
    @IBAction func savePrevProjectBtn_Click(_ sender: Any) {
        let projectName: String = projectNameTextField.text ?? ""
        let projectAddress: String = projectAddressTextField.text ?? ""
        let projectPurchase: String = projectPurchaseTextField.text ?? ""
        let projectBuild: String = projectBuildTextField.text ?? ""
        let projectSale: String = projectSaleTextField.text ?? ""
        let projectDate: String = projectCompleteDateTextField.text ?? ""
        let projectProfit: String = projectProfitTextField.text ?? ""
        let projectLender: String = projectLenderTextField.text ?? ""
        
        
        var prevProjectInfo: [String: Any] = [:]
        prevProjectInfo["name"] = projectName
        prevProjectInfo["address"] = projectAddress
        prevProjectInfo["purchase"] = projectPurchase
        prevProjectInfo["build"] = projectBuild
        prevProjectInfo["sale"] = projectSale
        prevProjectInfo["complete"] = projectDate
        prevProjectInfo["profit"] = projectProfit
        prevProjectInfo["lender"] = projectLender
        
        if !isNewPrevProject {
            prevProjectInfo["id"] = prevProjects[selectedIndex]["id"]
        }
        
        SVProgressHUD.show()
        FirebaseService.sharedInstance.updatePreviousProject(prevProject: prevProjectInfo) { (error) in
            if let error = error {
                SVProgressHUD.dismiss()
                let errorMessage: String = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            
            self.fetchPrevProjects()
        }
    }
    
    @IBAction func logoutBtn_Click(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "userInfo")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LogInVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
}

extension DeveloperProfileVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
    }
}
