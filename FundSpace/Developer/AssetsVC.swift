//
//  AssetsVC.swift
//  FundSpace
//
//  Created by admin on 9/16/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import AEAccordion
import SVProgressHUD

class AssetsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var expandableTableView: UITableView!
    var rightNavButtonItem: UIBarButtonItem!
    var assets: Array<String> = []
    private let options = [
        "Properties",
        "Loans, Current & Savings Accounts",
        "Stocks, Shares & Bonds",
        "Other Assets"
    ]
    
    private let suboptions = [
        ["Total Market Value:", "Outstanding Mortgage(s) Balance:"],
        ["Total Balance/Value:", "Total Loans/Overdrafts:"],
        ["Total Value:", "Total Liabliities:"],
        ["Total Assets:", "Total Liabilities:"]
    ]
    
    // MARK: Properties
    
    /// Array of `IndexPath` objects for all of the expanded cells.
    var expandedIndexPaths = [IndexPath]()
    
    /// Flag that indicates if cell toggle should be animated. Defaults to `true`.
    var isToggleAnimated = true
    
    /// Flag that indicates if `tableView` should scroll after cell is expanded,
    /// in order to make it completely visible (if it's not already). Defaults to `true`.
    var shouldScrollIfNeededAfterCellExpand = true
    
    /// Closure that will be called after any cell expand is completed.
    var expandCompletionHandler: () -> Void = {}
    
    /// Closure that will be called after any cell collapse is completed.
    var collapseCompletionHandler: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.clear)
        
        expandableTableView.register(UINib(nibName: "AssetsCell", bundle: nil), forCellReuseIdentifier: AssetsCell.reuseIdentifier)
        
        rightNavButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveAssetsAction))
        navigationItem.rightBarButtonItem = rightNavButtonItem
        
        if assets == [] {
            assets = [String](repeating: "", count: 8)
        }
        
    }
    
    @objc func saveAssetsAction() {
        SVProgressHUD.show()
        FirebaseService.sharedInstance.storeUserInfo(id: "", userInfo: ["assets": assets]) { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let errorMessage = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            UserDefaults.standard.set(self.assets, forKey: "assets")
            UserDefaults.standard.synchronize()
            
            Utils.sharedInstance.showSuccess(title: "Success", message: "Assets and Liabilities has been updated successfully.")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        assets[tag] = textField.text!
    }
    
    func toggleCell(_ cell: AssetsCell, animated: Bool) {
        if cell.expanded {
            collapseCell(cell, animated: animated)
        } else {
            expandCell(cell, animated: animated)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssetsCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? AssetsCell {
            cell.selectionStyle = .none
            cell.headerLabel.text = options[indexPath.row]
            
            let data = suboptions[indexPath.row]
            cell.firstLabel.text = data[0]
            cell.secondLabel.text = data[1]
            cell.firstTextField.delegate = self
            cell.secondTextField.delegate = self
            cell.firstTextField.tag = indexPath.row * 2
            cell.secondTextField.tag = indexPath.row * 2 + 1
            if assets.count > 0 {
                cell.firstTextField.text = assets[indexPath.row * 2]
                cell.secondTextField.text = assets[indexPath.row * 2 + 1]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AssetsCell {
            let expanded = expandedIndexPaths.contains(indexPath)
            cell.setExpanded(expanded, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AssetsCell {
            toggleCell(cell, animated: isToggleAnimated)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 210.0 : 80.0
    }
    
    // MARK: Helpers
    
    private func expandCell(_ cell: AssetsCell, animated: Bool) {
        if let indexPath = expandableTableView.indexPath(for: cell) {
            if !animated {
                addToExpandedIndexPaths(indexPath)
                cell.setExpanded(true, animated: false)
                expandableTableView.reloadData()
                scrollIfNeededAfterExpandingCell(at: indexPath)
                expandCompletionHandler()
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock { [weak self] in
                    self?.scrollIfNeededAfterExpandingCell(at: indexPath)
                    self?.expandCompletionHandler()
                }
                
                expandableTableView.beginUpdates()
                addToExpandedIndexPaths(indexPath)
                cell.setExpanded(true, animated: true)
                expandableTableView.endUpdates()
                
                CATransaction.commit()
            }
        }
    }
    
    private func collapseCell(_ cell: AssetsCell, animated: Bool) {
        if let indexPath = expandableTableView.indexPath(for: cell) {
            if !animated {
                cell.setExpanded(false, animated: false)
                removeFromExpandedIndexPaths(indexPath)
                expandableTableView.reloadData()
                collapseCompletionHandler()
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock { [weak self] in
                    self?.collapseCompletionHandler()
                }
                
                expandableTableView.beginUpdates()
                cell.setExpanded(false, animated: true)
                removeFromExpandedIndexPaths(indexPath)
                expandableTableView.endUpdates()
                
                CATransaction.commit()
            }
        }
    }
    
    private func addToExpandedIndexPaths(_ indexPath: IndexPath) {
        expandedIndexPaths.append(indexPath)
    }
    
    private func removeFromExpandedIndexPaths(_ indexPath: IndexPath) {
        if let index = expandedIndexPaths.firstIndex(of: indexPath) {
            expandedIndexPaths.remove(at: index)
        }
    }
    
    private func scrollIfNeededAfterExpandingCell(at indexPath: IndexPath) {
        guard shouldScrollIfNeededAfterCellExpand,
            let cell = expandableTableView.cellForRow(at: indexPath) as? AssetsCell else {
                return
        }
        let cellRect = expandableTableView.rectForRow(at: indexPath)
        let isCompletelyVisible = expandableTableView.bounds.contains(cellRect)
        if cell.expanded && !isCompletelyVisible {
            expandableTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
