//
//  SessionManager.swift
//  carpay
//
//  Created by Luke Newman on 7/31/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation
import Deferred

class SessionManager {

    private let networkUtility = SessionNetworkUtility()
    private let mockNetworkUtility = MockSessionNetworkUtility()

    private let isDebug = true

    func getSessions() -> Task<[Session]> {
        return isDebug ? mockNetworkUtility.fetchSessions() : networkUtility.getSessions()
    }

    func start(startRequest: Session.StartStopRequest) -> Task<Void> {
        return networkUtility.start(startRequest)
    }

    func stop(stopRequest: Session.StartStopRequest) -> Task<Void> {
        return networkUtility.stop(stopRequest)
    }

}

// MARK: - Networking

private class SessionNetworkUtility: NetworkUtility {

    let urlSession = URLSession(configuration: .default)
    
    func getSessions() -> Task<[Session]> {
        let deferred = Deferred<Task<[Session]>.Result>()

        let url = baseURL.withEndpoint(APIEndpoint.sessions)
        let request = URLRequest(url: url)

        let task = urlSession.dataTask(with: request) { (data, response, error) -> Void in
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
                // TODO: How to decode this as an array?
                let sessions = try decoder.decode(Session.self, from: data)
                deferred.succeed(with: [sessions])
            } catch {
                deferred.fail(with: error)
            }
        }

        task.resume()

        return Task(Future(deferred), cancellation: {
            task.cancel()
        })
    }

    func start(_ startRequest: Session.StartStopRequest) -> Task<Void> {
        let deferred = Deferred<Task<Void>.Result>()

        let encoder = JSONEncoder()
        var data: Data
        do {
            data = try encoder.encode(startRequest)
        } catch {
            deferred.fail(with: error)
            return Task(Future(deferred))
        }

        let request = URLRequest(baseURL, endpoint: .startSession, body: data)

        let task = urlSession.dataTask(with: request) { (_, response, error) in
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

    func stop(_ stopRequest: Session.StartStopRequest) -> Task<Void> {
        let deferred = Deferred<Task<Void>.Result>()

        let encoder = JSONEncoder()
        var data: Data
        do {
            data = try encoder.encode(stopRequest)
        } catch {
            deferred.fail(with: error)
            return Task(Future(deferred))
        }

        let request = URLRequest(baseURL, endpoint: .stopSession, body: data)

        let task = urlSession.dataTask(with: request) { (_, response, error) in
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

// MARK: - Mock Networking

private class MockSessionNetworkUtility {

    let sessions: [Session] = [Session(), Session(), Session(), Session()]

    func fetchSessions() -> Task<[Session]> {
        let deferred = Deferred<Task<[Session]>.Result>()

        DispatchQueue.any().asyncAfter(deadline: .now() + .milliseconds(2000)) {
            deferred.succeed(with: self.sessions)
        }

        return Task(Future(deferred))
    }

}
