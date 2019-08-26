//
//  AddProjectStep2VC.swift
//  FundSpace
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

class AddProjectStep2VC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var fundingTypeTextField: UITextField!
    @IBOutlet weak var fullPermissionTextField: UITextField!
    
    var typePicker: UIPickerView!
    var permissionPicker: UIPickerView!
    
    let typePickerData = ["Funding type", "Development", "Refurbishment", "Bridging", "Buy-to-let"]
    let permissionPickerData = ["Yes", "No"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
    func initPickerToolBar(picker: UIPickerView) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: picker == typePicker ? #selector(self.donePicker) : #selector(self.donePermissionPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    func initUI(){
        let borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        fundingTypeTextField.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 1)
        fullPermissionTextField.addBottomBorder(color: borderColor, margins: 0, borderLineSize: 1)
        
        typePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        typePicker.backgroundColor = .white
        typePicker.showsSelectionIndicator = true
        typePicker.delegate = self
        typePicker.dataSource = self
        
        let typeToolBar = initPickerToolBar(picker: typePicker)
        
        fundingTypeTextField.inputView = typePicker
        fundingTypeTextField.inputAccessoryView = typeToolBar
        
        permissionPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        permissionPicker.backgroundColor = .white
        
        permissionPicker.showsSelectionIndicator = true
        permissionPicker.delegate = self
        permissionPicker.dataSource = self
        
        let permissionToolBar = initPickerToolBar(picker: permissionPicker)
        
//        permissionPicker.selectRow(0, inComponent: 0, animated: true)
        
        fullPermissionTextField.inputView = permissionPicker
        fullPermissionTextField.inputAccessoryView = permissionToolBar
    }
    
    @objc func donePicker() {
        let row: Int? = typePicker.selectedRow(inComponent: 0)
        fundingTypeTextField.text = row != nil ? typePickerData[row!] : typePickerData[0]
        view.endEditing(true)
    }
    
    @objc func donePermissionPicker() {
        fullPermissionTextField.text = permissionPickerData[permissionPicker.selectedRow(inComponent: 0)]
        view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        view.endEditing(true)
    }
    
    // MARK: - PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == typePicker) {
            return typePickerData.count
        } else {
            return permissionPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == typePicker) {
            return typePickerData[row]
        } else {
            return permissionPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == typePicker) {
            fundingTypeTextField.text = typePickerData[row]
        } else {
            fullPermissionTextField.text = permissionPickerData[row]
        }
    }
    
    // MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
