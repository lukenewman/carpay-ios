//
//  FirstPageViewController.swift
//  pageview
//
//  Created by Greg Krathwohl on 10/25/17.
//  Copyright © 2017 CarPay LLC. All rights reserved.
//

import UIKit

class GradientBgViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBackground()
    }
    
    func loadBackground() {
        // Do any additional setup after loading the view.
        let topColor = UIColor(red:0.96, green:0.17, blue:0.25, alpha:1.0)
        let bottomColor = UIColor(red:0.24, green:0.13, blue:0.55, alpha:1.0)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
