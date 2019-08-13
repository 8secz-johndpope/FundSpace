//
//  TermsVC.swift
//  FundSpace
//
//  Created by adnin on 8/12/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import WebKit

class TermsVC: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var upBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI()
        loadLocalHTML()
    }
    
    func initUI() {
        // Make the circle button
        upBtn.layer.cornerRadius = 20
        
    }
    
    func loadLocalHTML() {
        let url = Bundle.main.url(forResource: "terms", withExtension: "html")!
        wkWebView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }

    @IBAction func upBtn_Click(_ sender: Any) {
        wkWebView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
