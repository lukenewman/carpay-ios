//
//  EditAccountViewController.swift
//  carpay
//
//  Created by Luke Newman on 8/18/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController, ManagerConfigurable, AuthenticationCoordinatorConfigurable {

    var managers: Managers?
    var authCoordinator: AuthenticationCoordinator?

    func configure(with managers: Managers) {
        self.managers = managers
    }

    func configure(with authCoordinator: AuthenticationCoordinator) {
        self.authCoordinator = authCoordinator
    }

    @IBAction func startSessionTapped(_ sender: Any) {
        guard let managers = managers else {
            preconditionFailure("Expected to have valid managers")
        }

        let startRequest = Session.StartStopRequest(lotID: 1234, plate: "DJF936", timestamp: Date())

        let task = managers.session.start(startRequest: startRequest)
        presentHUDDuring(task) { [unowned self] result in
            switch result {
            case .success:
                return
            case .failure(let error):
                let alert = UIAlertController.errorAlert(with: error)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func stopSessionTapped(_ sender: Any) {
        guard let managers = managers else {
            preconditionFailure("Expected to have valid managers")
        }

        let stopRequest = Session.StartStopRequest(lotID: 1234, plate: "DJF936", timestamp: Date())

        let task = managers.session.stop(stopRequest: stopRequest)
        presentHUDDuring(task) { [unowned self] result in
            switch result {
            case .success:
                return
            case .failure(let error):
                let alert = UIAlertController.errorAlert(with: error)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func logOutTapped(_ sender: Any) {
        managers?.authentication.logOut()
        authCoordinator?.didLogOut()
    }
}
