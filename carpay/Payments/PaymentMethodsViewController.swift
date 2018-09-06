//
//  PaymentMethodsViewController.swift
//  carpay
//
//  Created by Luke Newman on 5/17/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import UIKit
import Stripe

class PaymentMethodsViewController: UINavigationController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let paymentMethodsViewController = STPPaymentMethodsViewController()
        viewControllers = [paymentMethodsViewController]
    }

}
