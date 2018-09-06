//
//  HTTPMethod.swift
//  carpay
//
//  Created by Luke Newman on 7/28/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation

/// Represents the various HTTP methods, in a manner that allows for better type-safety than raw strings.
public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case get = "GET"
    case delete = "DELETE"
    case head = "HEAD"
}
