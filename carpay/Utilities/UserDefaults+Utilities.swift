//
//  UserDefaults+Utilities.swift
//  carpay
//
//  Created by Luke Newman on 5/18/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation

extension UserDefaults {
    var hasSeenIntro: Bool {
        get {
            return bool(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
