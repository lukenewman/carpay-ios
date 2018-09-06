//
//  User.swift
//  carpay
//
//  Created by Luke Newman on 5/17/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String = ""
    var password: String = ""
    var plate: String = ""
    var stripeToken: String = ""
}

extension User {
    struct LoginRequest: Codable {
        var email: String = ""
        var password: String = ""
    }
}
