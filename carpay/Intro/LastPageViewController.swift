//
//  LastPageViewController.swift
//  CarPay
//
//  Created by Greg Krathwohl on 10/26/17.
//  Copyright © 2017 CarPay LLC. All rights reserved.
//

import UIKit

class LastPageViewController: GradientBgViewController {

    @IBOutlet private var startButton: UIButton! {
        didSet {
            startButton.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.hasSeenIntro = true
    }

}
