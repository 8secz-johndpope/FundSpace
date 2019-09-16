//
//  AssetsVC.swift
//  FundSpace
//
//  Created by admin on 9/16/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import ExpandableCell

class AssetsVC: UIViewController, ExpandableDelegate {
    @IBOutlet weak var expandableTableView: ExpandableTableView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        expandableTableView.expandableDelegate = self
        expandableTableView.animation = .automatic
        //        expandableTableView.expansionStyle = .multi
        
        expandableTableView.register(UINib(nibName: "AssetsTableViewCell", bundle: nil), forCellReuseIdentifier: "assetsTableViewCell")
        expandableTableView.register(UINib(nibName: "ExpandedAssetsTableViewCell", bundle: nil), forCellReuseIdentifier: "expandedAssetsTableViewCell")
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: AssetsTableViewCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? AssetsTableViewCell {
            cell.headerDescriptionLabel.text = options[indexPath.row]
        }
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let expandedCell = expandableTableView.dequeueReusableCell(withIdentifier: "expandedAssetsTableViewCell") as! ExpandedAssetsTableViewCell
        let data = suboptions[indexPath.row]
        expandedCell.firstLabel.text = data[0]
        expandedCell.secondLabel.text = data[1]
        return [expandedCell]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [150.0]
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
