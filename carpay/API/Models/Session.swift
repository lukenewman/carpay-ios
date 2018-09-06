//
//  Session.swift
//  carpay
//
//  Created by Luke Newman on 7/31/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation

struct Session: Codable {
    var entry: Date
    var exit: Date
    var lotID: Int?
    var plate: String?
    var cost: Int?

    init() {
        entry = Date()
        exit = Date()
        lotID = nil
        plate = nil
        cost = nil
    }

    struct StartStopRequest: Codable {
        var lotID: Int
        var plate: String
        var timestamp: Date
    }
}
