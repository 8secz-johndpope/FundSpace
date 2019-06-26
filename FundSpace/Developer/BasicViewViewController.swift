//
//  BasicViewViewController.swift
//  FundSpace
//
//  Created by admin on 5/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class BasicViewViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var birhtdayTextField: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nationalityView: UIView!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initUI() {
        profileImageView.layer.cornerRadius = 65
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.borderWidth = 1.5
        profileImageView.clipsToBounds = true
        
        nameView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        phoneView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        locationView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        birthdayView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        nationalityView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
        
        nameTextField.delegate = self
        birhtdayTextField.delegate = self
        phoneTextField.delegate = self
        nationalityTextField.delegate = self
        locationTextField.delegate = self
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        birhtdayTextField.inputAccessoryView = toolbar
        birhtdayTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birhtdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @IBAction func imageProfileBtn_Click(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.nameTextField:
            nameView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            locationView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            phoneView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            birhtdayTextField.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            nationalityView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.phoneTextField:
            nameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            phoneView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            locationView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            birhtdayTextField.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            nationalityView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.locationTextField:
            nameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            phoneView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            locationView.addBottomBorder(color: UIColor.blue, margins: 0.0, borderLineSize: 1.5)
            birhtdayTextField.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            nationalityView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            break
        case self.birhtdayTextField:
            nameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            birhtdayTextField.addBottomBorder(color: .blue, margins: 0.0, borderLineSize: 1.5)
            phoneView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            locationView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            nationalityView.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            showDatePicker()
            break
        case self.nationalityTextField:
            nameView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            birhtdayTextField.addBottomBorder(color: .lightGray, margins: 0.0, borderLineSize: 1.5)
            phoneView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            locationView.addBottomBorder(color: UIColor.lightGray, margins: 0.0, borderLineSize: 1.5)
            nationalityView.addBottomBorder(color: .blue, margins: 0.0, borderLineSize: 1.5)
        default:
            break
        }
    }
}

extension BasicViewViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.profileImageView.image = image
    }
}
