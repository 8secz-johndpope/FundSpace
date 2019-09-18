//
//  LeaderDeveloperProfileVC.swift
//  FundSpace
//
//  Created by admin on 9/11/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import M13ProgressSuite
import Charts
import SVProgressHUD

class LeaderDeveloperProfileVC: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var currentProjectsBtn: UIButton!
    
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
    @IBOutlet weak var projectLenderTextField: UITextField!
    
    @IBOutlet weak var creditPositionView: UIView!
    @IBOutlet weak var creditPositionProgressBar: M13ProgressViewBar!
    
    @IBOutlet weak var assetsView: UIView!
    @IBOutlet weak var assetsChatView: BarChartView!
    
    @IBOutlet weak var uploadDocumentBtn: UIButton!
    
    var userInfo: [String: Any] = [:]
    var prevProjects: Array<[String: Any]> = []
    var selectedIndex: Int = 0
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        initUI()
        makeEditable(false)
        fetchInitData()
        initProgressBar()
        initChartView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initUI() {
        let bordorColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        basicInfoView.makeRoundShadowView()
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageBtn.setImage(UIImage(named: "circle_border.png"), for: .normal)
        
        messageBtn.layer.cornerRadius = 4
        currentProjectsBtn.layer.cornerRadius = 4
        currentProjectsBtn.layer.borderColor = UIColor(red: 0.57, green: 0.57, blue: 0.57, alpha: 1).cgColor
        currentProjectsBtn.layer.borderWidth = 1
        
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
        
        creditPositionView.makeRoundShadowView()
        creditPositionProgressBar.showPercentage = false
        
        assetsView.makeRoundShadowView()
        
        uploadDocumentBtn.layer.cornerRadius = 4
        
        assetsChatView.delegate = self
        
        let labels = [
            "Current & Savings Account",
            "Properties",
            "Stocks, Shares & Bonds",
            "Other Assets"
        ]
        
        let l = assetsChatView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.font = UIFont(name: "OpenSans", size: 8.8)!
        l.yOffset = 10
        l.xOffset = 10
        l.yEntrySpace = 0
        //        chartView.legend = l
        
        let xAxis = assetsChatView.xAxis
        xAxis.labelFont = UIFont(name: "OpenSans", size: 9)!
        xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        xAxis.labelPosition = .bottom
        xAxis.wordWrapEnabled = true
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        
        assetsChatView.rightAxis.enabled = false
        assetsChatView.leftAxis.enabled = false
        assetsChatView.extraBottomOffset = 30
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
    }
    
    func getOptionArray() -> Array<String> {
        var options: Array<String> = []
        for prevProject in prevProjects {
            options.append(prevProject["name"] as! String)
        }
        
        return options
    }
    
    func configureProjectView(index: Int) {
        let prevProject = prevProjects[index]
        projectNameTextField.text = prevProject["name"] as? String ?? ""
        projectAddressTextField.text = prevProject["address"] as? String ?? ""
        projectPurchaseTextField.text = prevProject["purchase"] as? String ?? ""
        projectBuildTextField.text = prevProject["build"] as? String ?? ""
        projectSaleTextField.text = prevProject["sale"] as? String ?? ""
        projectCompleteDateTextField.text = prevProject["complete"] as? String ?? ""
        projectProfitTextField.text = prevProject["profit"] as? String ?? ""
        projectLenderTextField.text = prevProject["lender"] as? String ?? ""
            
    }
    
    func initDropDown() {
        let optionArray = getOptionArray()
        
        projectsDropDown.optionArray = optionArray
        
        // Select first element by default.
        if (optionArray.count > 0) {
            let selectedText = optionArray[0]
            projectsDropDown.text = selectedText
            projectsDropDown.select(selectedText)
            configureProjectView(index: 0)
        }
    }
    
    func fetchPrevProjects() {
        FirebaseService.sharedInstance.fetchPreviousProjects(userID, completion: { (prevProjects, error) in
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
    
    func initProgressBar() {
        let creditPositions: [[String:Int]] = userInfo["creditPositions"] as? [[String:Int]] ?? []
        if creditPositions.count == 0 {
            return
        }
        let position = creditPositions[0]["mainNo"]! + creditPositions[1]["mainNo"]! + creditPositions[2]["mainNo"]! + creditPositions[3]["mainNo"]!
        creditPositionProgressBar.setProgress(CGFloat(position) / 4.0, animated: true)
    }
    
    func initChartView() {
        let assets: Array<String> = userInfo["assets"] as? Array<String> ?? []
        
        let groupSpace = 0.4
        let barSpace = 0.0
        let barWidth = 0.3
        
        
        let block: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(assets[i]) as! Double)
        }
        let yVals1 = stride(from: 0, to: assets.count, by: 2).map(block)
        let yVals2 = stride(from: 1, to: assets.count, by: 2).map(block)
        
        let set1 = BarChartDataSet(entries: yVals1, label: "Assets")
        set1.setColor(UIColor(red: 0, green: 0.49, blue: 1, alpha: 1))
        set1.drawValuesEnabled = false
        
        let set2 = BarChartDataSet(entries: yVals2, label: "Liabilities")
        set2.setColor(UIColor(red: 0.43, green: 0.8, blue: 0.76, alpha: 1))
        set2.drawValuesEnabled = false
        
        let data = BarChartData(dataSets: [set1, set2])
        
        
        // specify the width each bar should have
        data.barWidth = barWidth
        
        // restrict the x-axis range
        assetsChatView.xAxis.axisMinimum = 0
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        assetsChatView.xAxis.axisMaximum = 4
        
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        assetsChatView.data = data
    }
    
    func fetchInitData() {
        
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
    
    func findChannel(completion: @escaping (Channel) -> Void) {
        FirebaseService.sharedInstance.findChannel(id: userID) { (queryDocument, error) in
            if error != nil {
                let name: String = self.userInfo["name"] as? String ?? ""
                let image: String = self.userInfo["profile_pic"] != nil ? self.userInfo["profile_pic"] as! String : ""
                FirebaseService.sharedInstance.addChannel(name: name, receiver: self.userID, message: "", image: image, completition: { (channel, error) in
                    completion(channel!)
                })
            } else if queryDocument == nil {
                let name: String = self.userInfo["name"] as? String ?? ""
                let image: String = self.userInfo["profile_pic"] != nil ? self.userInfo["profile_pic"] as! String : ""
                FirebaseService.sharedInstance.addChannel(name: name, receiver: self.userID, message: "", image: image, completition: { (channel, error) in
                    completion(channel!)
                })
            } else {
                completion(Channel(document: queryDocument!)!)
            }
        }
    }
    
    @IBAction func messageBtn_Click(_ sender: Any) {
        findChannel { (channel) in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "chatVC") as! ChatVC
            newViewController.userName = self.userInfo["name"] != nil ? self.userInfo["name"] as! String : "No Name"
            newViewController.userProfileImage = self.profileImageView.image!
            newViewController.channel = channel
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @IBAction func currentProjectBtn_Click(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "leaderCurrentProjectsVC") as! LeaderCurrentProjectsVC
        newViewController.user_id = userID
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func uploadDocumentBtn_Click(_ sender: Any) {
    }

}
