//
//  AddProjectStep6VC.swift
//  FundSpace
//
//  Created by admin on 8/26/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddProjectStep6VC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var checkBoxContainer: UIView!
    @IBOutlet weak var firstCheckBox: Checkbox!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondCheckBox: Checkbox!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var fundDuration: SkyFloatingLabelTextField!
    
    let selectColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
    let unSelectColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    let unSelectTextColor = UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1)
    
    var durationPicker: UIPickerView!
    
    let durationData = ["more than 6 months", "6 months", "5 months", "3 months", "1 month", "less than a month"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
    }
    
//    func updateCheckBox(checkBox: Checkbox, isChecked: Bool) {
//        firstCheckBox.checkedBorderColor = selectColor
//        firstCheckBox.uncheckedBorderColor = unSelectColor
//        firstCheckBox.borderStyle = .circle
//        firstCheckBox.checkmarkColor = selectColor
//        firstCheckBox.checkmarkStyle = .circle
//    }
    
    func initUI() {
        checkBoxContainer.addBottomBorder(color: unSelectColor, margins: 0, borderLineSize: 1)
        firstCheckBox.checkedBorderColor = selectColor
        firstCheckBox.uncheckedBorderColor = unSelectColor
        firstCheckBox.borderStyle = .circle
        firstCheckBox.checkmarkColor = selectColor
        firstCheckBox.checkmarkStyle = .circle
        
        secondCheckBox.checkedBorderColor = selectColor
        secondCheckBox.uncheckedBorderColor = unSelectColor
        secondCheckBox.borderStyle = .circle
        secondCheckBox.checkmarkColor = selectColor
        secondCheckBox.checkmarkStyle = .circle
        
        firstCheckBox.isChecked = true
        firstLabel.textColor = selectColor
        
        secondCheckBox.isChecked = false
        secondLabel.textColor = unSelectTextColor
        
        fundDuration.font = UIFont(name: "OpenSans", size: 15)
        fundDuration.textAlignment = .center
        
        durationPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        durationPicker.backgroundColor = .white
        durationPicker.showsSelectionIndicator = true
        durationPicker.delegate = self
        durationPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        fundDuration.inputView = durationPicker
        fundDuration.inputAccessoryView = toolBar
        
        firstCheckBox.valueChanged = { (value) in
            self.firstCheckBox.isChecked = true
            self.firstLabel.textColor = self.selectColor
            
            self.secondCheckBox.isChecked = false
            self.secondLabel.textColor = self.unSelectTextColor
            
        }
        
        secondCheckBox.valueChanged = { (value) in
            self.firstCheckBox.isChecked = false
            self.firstLabel.textColor = self.unSelectTextColor
            
            self.secondCheckBox.isChecked = true
            self.secondLabel.textColor = self.selectColor
        }
    }
    
    @objc func donePicker() {
        let row: Int? = durationPicker.selectedRow(inComponent: 0)
        fundDuration.text = row != nil ? durationData[row!] : durationData[0]
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
        return durationData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fundDuration.text = durationData[row]
    }
}
