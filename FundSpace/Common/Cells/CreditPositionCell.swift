//
//  CreditPositionCell.swift
//  FundSpace
//
//  Created by admin on 9/18/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import AEAccordion

protocol CreditPositionCellDelegate: class {
    func didPressMainYesButton(_ tag: Int)
    func didPressMainNoButton(_ tag: Int)
    func didPressSecondYesButton(_ tag: Int)
    func didPressSecondNoButton(_ tag: Int)
}

class CreditPositionCell: AccordionTableViewCell {
    
    static let reuseIdentifier = "creditPositionCell"

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var mainYesBtn: UIButton!
    @IBOutlet weak var mainNoBtn: UIButton!
    @IBOutlet weak var secondYesBtn: UIButton!
    @IBOutlet weak var secondNoBtn: UIButton!
    
    var cellDelegate: CreditPositionCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }
    
    func initUI() {
        mainYesBtn.layer.cornerRadius = 6
        mainYesBtn.layer.borderWidth = 1
        mainYesBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        mainYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        
        mainNoBtn.layer.cornerRadius = 6
        mainNoBtn.layer.borderWidth = 1
        mainNoBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        mainNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        
        secondYesBtn.layer.cornerRadius = 6
        secondYesBtn.layer.borderWidth = 1
        secondYesBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        secondYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        
        secondNoBtn.layer.cornerRadius = 6
        secondNoBtn.layer.borderWidth = 1
        secondNoBtn.layer.borderColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1).cgColor
        secondNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
    }
    
    // MARK: Override
    
    override func setExpanded(_ expanded: Bool, animated: Bool) {
        super.setExpanded(expanded, animated: animated)
        
        if animated {
            let alwaysOptions: UIView.AnimationOptions = [.allowUserInteraction,
                                                          .beginFromCurrentState,
                                                          .transitionCrossDissolve]
            let expandedOptions: UIView.AnimationOptions = [.transitionFlipFromTop, .curveEaseOut]
            let collapsedOptions: UIView.AnimationOptions = [.transitionFlipFromBottom, .curveEaseIn]
            let options = expanded ? alwaysOptions.union(expandedOptions) : alwaysOptions.union(collapsedOptions)
            
            UIView.transition(with: detailView, duration: 0.3, options: options, animations: {
                self.toggleCell()
            }, completion: nil)
        } else {
            toggleCell()
        }
    }
    
    // MARK: Helpers
    
    private func toggleCell() {
        detailView.isHidden = !expanded
        arrow.transform = expanded ? CGAffineTransform(rotationAngle: CGFloat.pi) : .identity
    }
    
    @IBAction func mainYesBtn_Click(_ sender: UIButton) {
        mainYesBtn.setTitleColor(.white, for: .normal)
        mainYesBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        mainNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        mainNoBtn.backgroundColor = .clear
        
        cellDelegate.didPressMainYesButton(sender.tag)
    }
    
    @IBAction func mainNoBtn_Click(_ sender: UIButton) {
        mainNoBtn.setTitleColor(.white, for: .normal)
        mainNoBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        mainYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        mainYesBtn.backgroundColor = .clear
        
        cellDelegate.didPressMainNoButton(sender.tag)
    }
    
    
    @IBAction func secondYesBtn_Click(_ sender: UIButton) {
        secondYesBtn.setTitleColor(.white, for: .normal)
        secondYesBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        secondNoBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        secondNoBtn.backgroundColor = .clear
        
        cellDelegate.didPressSecondYesButton(sender.tag)
    }
    
    @IBAction func secondNoBtn_Click(_ sender: UIButton) {
        secondNoBtn.setTitleColor(.white, for: .normal)
        secondNoBtn.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)
        
        secondYesBtn.setTitleColor(UIColor(red: 0.14, green: 0.18, blue: 0.23, alpha: 1), for: .normal)
        secondYesBtn.backgroundColor = .clear
                
        cellDelegate.didPressSecondNoButton(sender.tag)
    }

}
