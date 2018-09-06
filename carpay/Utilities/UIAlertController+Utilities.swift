//
//  UIAlertController+Utilities.swift
//  carpay
//
//  Created by Luke Newman on 5/14/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func errorAlert(with error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        return alertController
    }
}

