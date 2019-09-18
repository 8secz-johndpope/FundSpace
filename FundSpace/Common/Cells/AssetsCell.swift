//
//  AssetsCell.swift
//  FundSpace
//
//  Created by admin on 9/18/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import AEAccordion

class AssetsCell: AccordionTableViewCell {
    
    static let reuseIdentifier = "assetsCell"
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

}
