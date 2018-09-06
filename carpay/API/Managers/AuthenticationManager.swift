//
//  AuthenticationManager.swift
//  carpay
//
//  Created by Luke Newman on 7/28/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation
import Deferred

class AuthenticationManager {
    private let networkUtility = AuthenticationNetworkUtility()

    private var token: Token?

    var isAuthenticated: Bool {
        return token != nil
    }

    func attemptLogin(with email: String, _ password: String) -> Task<Token> {
        return networkUtility.attemptLogin(with: email, password)
    }

    // TODO: Hook this up to backend
    func logOut() {
        token = nil
    }
}

// MARK: - Networking

private class AuthenticationNetworkUtility: NetworkUtility {
    let session = URLSession(configuration: .default)

    func attemptLogin(with email: String, _ password: String) -> Task<Token> {
        let deferred = Deferred<Task<Token>.Result>()

        let loginRequest = User.LoginRequest(email: email, password: password)

        let encoder = JSONEncoder()

        var data: Data
        do {
            data = try encoder.encode(loginRequest)
        } catch {
            deferred.fail(with: error)
            return Task(Future(deferred))
        }

        let request = URLRequest(baseURL, endpoint: .login, body: data)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                deferred.fail(with: error)
                return
            }
            guard let data = data else {
                deferred.fail(with: Error.noData)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                deferred.fail(with: Error.noData)
                return
            }
            guard httpResponse.statusCode == 200 else {
                deferred.fail(with: Error.HTTPError(statusCode: httpResponse.statusCode))
                return
            }

            let decoder = JSONDecoder()
            do {
                let token = try decoder.decode(Token.self, from: data)
                deferred.succeed(with: token)
            } catch {
                deferred.fail(with: error)
            }
        }

        task.resume()

        return Task(Future(deferred), cancellation: {
            task.cancel()
        })
    }
}
