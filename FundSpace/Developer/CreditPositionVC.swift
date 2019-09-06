//
//  CreditPositionVC.swift
//  FundSpace
//
//  Created by admin on 9/4/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import ExpandableCell
import M13ProgressSuite

class CreditPositionVC: UIViewController, ExpandableDelegate {
        
    @IBOutlet weak var progressBar: M13ProgressViewBar!
    @IBOutlet weak var expandableTableView: ExpandableTableView!
    
    private let options = [
        "Bankruptcies or individual voluntary arrangements",
        "Registered court judgements or CCJ",
        "Officer of a company in which a receiver or liquidator was appointed",
        "Missed mortagage payments or secured loan repayments in the last 36 months"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        expandableTableView.expandableDelegate = self
        expandableTableView.animation = .automatic
//        expandableTableView.expansionStyle = .multi
        
        expandableTableView.register(UINib(nibName: "creditPositionCell", bundle: nil), forCellReuseIdentifier: "creditPositionCell")
        expandableTableView.register(UINib(nibName: "expandedCreditPositionCell", bundle: nil), forCellReuseIdentifier: "expandedCreditPositionCell")
        progressBar.showPercentage = false
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: CreditPositionTableViewCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? CreditPositionTableViewCell {
            cell.headerDescriptionLabel.text = options[indexPath.row]
        }
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let expandedCell = expandableTableView.dequeueReusableCell(withIdentifier: "expandedCreditPositionCell") as! ExpandedCreditPositionTableViewCell
        return [expandedCell]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [150.0]
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
