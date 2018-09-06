//
//  TableViewUtilities.swift
//  carpay
//
//  Created by Luke Newman on 8/2/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func reuseIdentifier() -> String {
        return NSStringFromClass(self)
    }
}
