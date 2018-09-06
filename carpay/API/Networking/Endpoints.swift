//
//  Endpoints.swift
//  carpay
//
//  Created by Luke Newman on 7/28/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation

enum APIEndpoint {
    case login
    case users
    case sessions
    case startSession
    case stopSession

    var path: String {
        switch self {
        case .login:
            return "/login"
        case .users:
            return "/users"
        case .sessions:
            return "/sessions"
        case .startSession:
            return "/start"
        case .stopSession:
            return "/stop"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .users, .startSession, .stopSession:
            return .post
        case .sessions:
            return .get
        }
    }
}

extension URL {
    func withEndpoint(_ endpoint: APIEndpoint) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true)  else {
            fatalError("Base URL is invalid: \(self)")
        }
        guard endpoint.path.first == "/" else {
            fatalError("Endpoint paths should being with a '/'")
        }

        components.path = path.appending(endpoint.path)

        guard let url = components.url else {
            fatalError("Failed to forulate endpoint url with components \(components)")
        }
        return url
    }
}

extension URLRequest {
    init(_ baseURL: URL, endpoint: APIEndpoint, body: Data? = nil) {
        let url = baseURL.withEndpoint(endpoint)
        self.init(url: url)

        httpMethod = endpoint.method.rawValue
        httpBody = body

        if endpoint.method == .post {
            setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}

