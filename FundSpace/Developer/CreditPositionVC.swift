//
//  CreditPositionVC.swift
//  FundSpace
//
//  Created by admin on 9/4/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import AEAccordion
import M13ProgressSuite
import SVProgressHUD

class CreditPositionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CreditPositionCellDelegate {
        
    @IBOutlet weak var progressBar: M13ProgressViewBar!
    @IBOutlet weak var expandableTableView: UITableView!
    var rightNavButtonItem: UIBarButtonItem!
    var creditPositions: [[String: Int]] = []
    
    private let options = [
        "Bankruptcies or individual voluntary arrangements",
        "Registered court judgements or CCJ",
        "Officer of a company in which a receiver or liquidator was appointed",
        "Missed mortagage payments or secured loan repayments in the last 36 months"
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
        
        expandableTableView.register(UINib(nibName: "CreditPositionCell", bundle: nil), forCellReuseIdentifier: CreditPositionCell.reuseIdentifier)
        progressBar.showPercentage = false
        
        rightNavButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveCreditPositionAction))
        navigationItem.rightBarButtonItem = rightNavButtonItem
        
        if creditPositions.count == 0 {
            let item = [
                "mainYes": 0,
                "mainNo": 0,
                "secondYes": 0,
                "secondNo": 0
            ]
            creditPositions = Array(repeating: item, count: 4)
        }
        
        drawProgressBar()
        
    }
    
    func drawProgressBar() {
        let position = creditPositions[0]["mainNo"]! + creditPositions[1]["mainNo"]! + creditPositions[2]["mainNo"]! + creditPositions[3]["mainNo"]!
        progressBar.setProgress(CGFloat(position) / 4.0, animated: true)
    }
    
    @objc func saveCreditPositionAction() {
        SVProgressHUD.show()
        FirebaseService.sharedInstance.storeUserInfo(id: "", userInfo: ["creditPositions": creditPositions]) { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let errorMessage = error.localizedDescription
                Utils.sharedInstance.showError(title: "Error", message: errorMessage)
                return
            }
            
            UserDefaults.standard.set(self.creditPositions, forKey: "creditPositions")
            UserDefaults.standard.synchronize()
            
            Utils.sharedInstance.showSuccess(title: "Success", message: "Credit Position has been updated successfully.")
        }
    }
    
    func toggleCell(_ cell: CreditPositionCell, animated: Bool) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CreditPositionCell.reuseIdentifier, for: indexPath)

        if let cell = cell as? CreditPositionCell {
            cell.selectionStyle = .none
            cell.headerLabel.text = options[indexPath.row]
            cell.cellDelegate = self
            cell.mainYesBtn.tag = indexPath.row
            cell.mainNoBtn.tag = indexPath.row
            cell.secondYesBtn.tag = indexPath.row
            cell.secondNoBtn.tag = indexPath.row

            let data: [String: Int] = creditPositions[indexPath.row]
            if data["mainYes"] == 1 {
                cell.mainYesBtn.setTitleColor(.white, for: .normal)
                cell.mainYesBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
            }

            if data["mainNo"] == 1 {
                cell.mainNoBtn.setTitleColor(.white, for: .normal)
                cell.mainNoBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
            }

            if data["secondYes"] == 1 {
                cell.secondYesBtn.setTitleColor(.white, for: .normal)
                cell.secondYesBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
            }

            if data["secondNo"] == 1 {
                cell.secondNoBtn.setTitleColor(.white, for: .normal)
                cell.secondNoBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CreditPositionCell {
            let expanded = expandedIndexPaths.contains(indexPath)
            cell.setExpanded(expanded, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CreditPositionCell {
            toggleCell(cell, animated: isToggleAnimated)
        }
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 210.0 : 80.0
    }
    
    // MARK: Helpers
    
    private func expandCell(_ cell: CreditPositionCell, animated: Bool) {
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
    
    private func collapseCell(_ cell: CreditPositionCell, animated: Bool) {
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
            let cell = expandableTableView.cellForRow(at: indexPath) as? CreditPositionCell else {
                return
        }
        let cellRect = expandableTableView.rectForRow(at: indexPath)
        let isCompletelyVisible = expandableTableView.bounds.contains(cellRect)
        if cell.expanded && !isCompletelyVisible {
            expandableTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func didPressMainYesButton(_ tag: Int) {
        creditPositions[tag]["mainYes"] = 1
        creditPositions[tag]["mainNo"] = 0
        
        drawProgressBar()
    }
    
    func didPressMainNoButton(_ tag: Int) {
        creditPositions[tag]["mainNo"] = 1
        creditPositions[tag]["mainYes"] = 0
        
        drawProgressBar()
    }
    
    func didPressSecondYesButton(_ tag: Int) {
        creditPositions[tag]["secondYes"] = 1
        creditPositions[tag]["secondNo"] = 0
        
        drawProgressBar()
    }
    
    func didPressSecondNoButton(_ tag: Int) {
        creditPositions[tag]["secondNo"] = 1
        creditPositions[tag]["secondYes"] = 0
        
        drawProgressBar()
    }
}
