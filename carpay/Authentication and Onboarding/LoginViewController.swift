//
//  ViewController.swift
//  CarPay
//
//  Created by Luke Newman on 7/9/18.
//  Copyright © 2017 CarPay LLC. All rights reserved.
//

/*

 TODO

 - actually get light content status bar
 - keyboard avoidance

 */

import UIKit

class LoginViewController: GradientBgViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    fileprivate var authenticationCoordinator: AuthenticationCoordinator?
    fileprivate var managers: Managers?

    private enum SegueIdentifier: String {
        case showCreateAccountViewController
    }

    @IBOutlet private var formWrapperView: UIView! {
        didSet {
            formWrapperView.layer.cornerRadius = Design.VisualConstants.cornerRadius
        }
    }
    @IBOutlet var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet private var logInButton: UIButton! {
        didSet {
            logInButton.layer.cornerRadius = Design.VisualConstants.cornerRadius
        }
    }
    @IBOutlet private var createAccountButton: UIButton! {
        didSet {
            createAccountButton.layer.cornerRadius = Design.VisualConstants.cornerRadius
        }
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        emailTextField.addTarget(self, action: #selector(formChanged(_:)), for: .editingChanged)
//        passwordTextField.addTarget(self, action: #selector(formChanged(_:)), for: .editingChanged)
    }

    func configure(with coordinator: AuthenticationCoordinator, managers: Managers) {
        authenticationCoordinator = coordinator
        self.managers = managers
    }

    @IBAction func logInButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        guard let managers = managers else {
            preconditionFailure("Expected to have valid Managers")
        }

        let task = managers.authentication.attemptLogin(with: email, password)
        presentHUDDuring(task) { [unowned self] result in
            switch result {
            case .success:
                self.authenticationCoordinator?.didLogIn()
            case .failure(let error):
                let alert = UIAlertController.errorAlert(with: error)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction private func createAccountButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.showCreateAccountViewController.rawValue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier.flatMap({ SegueIdentifier(rawValue: $0) }) else {
            preconditionFailure("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }

        switch segueIdentifier {
        case .showCreateAccountViewController:
            guard let destination = segue.destination as? UINavigationController else {
                preconditionFailure("Expected destination of showOnboardingFlow segue to be of type UINavigationController")
            }
            guard let createAccountViewController = destination.topViewController as? CreateAccountViewController else {
                preconditionFailure("Expected topViewController of OnboardingNavigationController to be a CreateAccountViewController")
            }
            guard let coordinator = authenticationCoordinator else {
                preconditionFailure("Expected to have a valid AuthenticationCoordinator to pass")
            }
            guard let managers = managers else {
                preconditionFailure("Expected to have valid Managers to pass")
            }

            destination.navigationBar.barTintColor = .white
            destination.navigationBar.shadowImage = UIImage()

            createAccountViewController.configure(with: coordinator, managers)

            return
        }
    }

}

// MARK: - UITextField Observer

extension LoginViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return textField == passwordTextField
//    }
}
