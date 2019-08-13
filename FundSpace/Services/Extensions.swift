//
//  Extensions.swift
//  FundSpace
//
//  Created by adnin on 8/12/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit

extension UIViewController {
    open override func awakeFromNib() {
        // Remove navigation back buttton title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
