//
//  GradientView.swift
//  carpay
//
//  Created by Luke Newman on 7/9/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(with: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup(with frame: CGRect? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame ?? self.frame
        gradientLayer.colors = [Design.Colors.purple.cgColor, Design.Colors.red.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        layer.insertSublayer(gradientLayer, at: 0)
    }

}
