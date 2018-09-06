//
//  OnboardingNetworkUtility.swift
//  carpay
//
//  Created by Luke Newman on 7/28/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation
import Deferred

public typealias FetchSomethingTask = Task<Any>

class NetworkUtility {
    lazy var baseURL: URL = {
        guard let url = URL(string: "http://localhost:8080") else {
            preconditionFailure("Unable to create baseURL")
        }
//        guard let url = URL(string: "https://desolate-woodland-76976.herokuapp.com") else {
//            preconditionFailure("Unable to create baseURL")
//        }
        return url
    }()

    // Errors that will propagate back via the Tasks
    enum Error: LocalizedError {
        case noData
        case HTTPError(statusCode: Int)

        public var errorDescription: String? {
            switch self {
            case .noData:
                return NSLocalizedString("No data was returned from the server.", comment: "Error message when the server failed to return data.")

            case .HTTPError(let statusCode):
                let formatString = NSLocalizedString("The server returned an error. (status: %d)", comment: "Error message when the server fails with a non-200 status code.")
                return String(format: formatString, statusCode)
            }
        }
    }
}
