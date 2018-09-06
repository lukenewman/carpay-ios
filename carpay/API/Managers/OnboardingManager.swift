//
//  OnboardingManager.swift
//  carpay
//
//  Created by Luke Newman on 7/28/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation
import Deferred

class OnboardingManager {
    private let networkUtility = OnboardingNetworkUtility()

    var onboardingUser: User = User()

    func onboardingUserDidStart(with email: String, and password: String) {
        // TODO - check if email already exists

        onboardingUser.email = email
        onboardingUser.password = password
    }

    func onboardingUserDidAdd(plate: String) {
        // TODO - check if plate already exists

        onboardingUser.plate = plate
    }

    func onboardingUserDidAdd(stripeToken: String) {
        onboardingUser.stripeToken = stripeToken
    }

    func onboardingUserDidFinish() -> Task<Void> {
        return networkUtility.create(user: onboardingUser)
    }
}

// MARK: - Networking

private class OnboardingNetworkUtility: NetworkUtility {

    let session = URLSession(configuration: .default)

    func create(user: User) -> Task<Void> {
        let deferred = Deferred<Task<Void>.Result>()

        let encoder = JSONEncoder()

        var data: Data
        do {
            data = try encoder.encode(user)
        } catch {
            deferred.fail(with: error)
            return Task(Future(deferred))
        }

        let request = URLRequest(baseURL, endpoint: .users, body: data)

        let task = session.dataTask(with: request) { (_, response, error) in
            if let error = error {
                deferred.fail(with: error)
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

            deferred.succeed()
        }

        task.resume()

        return Task(Future(deferred), cancellation: {
            task.cancel()
        })
    }
}
