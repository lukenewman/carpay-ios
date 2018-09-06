//
//  CreateAccountViewController.swift
//  carpay
//
//  Created by Luke Newman on 7/9/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

/*

 TODO

 - autofill fields from an "you need to create an account" login result
 - navigation bar styling
 - error states
 - email validation

 */

import UIKit

private struct FormState {
    var email: String?
    var password: String?

    var hasProperEmail: Bool = false
    var hasProperPassword: Bool = false

    var isValid: Bool {
        return hasProperEmail && hasProperPassword
    }
}

private enum SegueIdentifier: String {
    case showLicensePlateEntryViewController
}

class CreateAccountViewController: UIViewController {

    private var authenticationCoordinator: AuthenticationCoordinator?
    private var managers: Managers?

    fileprivate var formState = FormState()

    // MARK: @IBOutlets

    @IBOutlet private var formWrapperView: UIView! {
        didSet {
            formWrapperView.layer.borderWidth = Design.VisualConstants.borderWidth
            formWrapperView.layer.borderColor = Design.Colors.red.cgColor
            formWrapperView.layer.cornerRadius = Design.VisualConstants.cornerRadius
        }
    }
    @IBOutlet private var emailTextField: UITextField! {
        didSet {
            emailTextField.keyboardType = .emailAddress
            emailTextField.autocorrectionType = .no
            emailTextField.autocapitalizationType = .none
        }
    }
    @IBOutlet private var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet var togglePasswordVisibilityButton: UIButton!
    @IBOutlet private var nextButton: UIButton! {
        didSet {
            nextButton.isEnabled = true // PROD = false, DEBUG = true
            nextButton.layer.cornerRadius = Design.VisualConstants.cornerRadius
        }
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        emailTextField.addTarget(self, action: #selector(formChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(formChanged(_:)), for: .editingChanged)
    }

    func configure(with coordinator: AuthenticationCoordinator, _ managers: Managers) {
        authenticationCoordinator = coordinator
        self.managers = managers
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: @IBActions

    @IBAction func togglePasswordVisibility(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    @IBAction private func nextButtonTapped(_ sender: Any) {
        guard formState.isValid else {
            preconditionFailure("Next button should not be enabled with invalid FormState")
        }
        guard let email = formState.email, let password = formState.password else {
            preconditionFailure("Expected to have a valid email and password from a valid FormState")
        }
        guard let managers = managers else {
            preconditionFailure("Expected to have valid Managers")
        }

        managers.onboarding.onboardingUserDidStart(with: email, and: password)

        performSegue(withIdentifier: SegueIdentifier.showLicensePlateEntryViewController.rawValue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier.flatMap({ SegueIdentifier(rawValue: $0) }) else {
            preconditionFailure("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }

        switch segueIdentifier {
        case .showLicensePlateEntryViewController:
            guard let destination = segue.destination as? LicensePlateEntryViewController else {
                preconditionFailure("Expected destination of showLicensePlateEntryViewController segue to be of type LicensePlateEntryViewController")
            }
            guard let coordinator = authenticationCoordinator else {
                preconditionFailure("Expected to have a valid AuthenticationCoordinator to pass")
            }
            guard let managers = managers else {
                preconditionFailure("Expected to have valid Managers to pass")
            }

            destination.configure(with: coordinator, managers)

            return
        }
    }
}

// MARK: - UITextField Observer

extension CreateAccountViewController {
    @objc fileprivate func formChanged(_ sender: UITextField) {
        if sender == emailTextField {
            guard let email = emailTextField.text else {
                preconditionFailure("Failed to get email from emailTextField")
            }
            guard email.isValidEmail else {
                // TODO - error: invalid email
                return
            }
            formState.email = email
            formState.hasProperEmail = true
        } else if sender == passwordTextField {
            guard let password = passwordTextField.text, !password.isEmpty else {
                // TODO - error: need a password
                return
            }
            // TODO - validate password
            formState.password = password
            formState.hasProperPassword = true
        }

        nextButton.isEnabled = formState.isValid
    }
}

// MARK: Form Validation

extension String {
    var isValidEmail: Bool {
        // TODO
        return true
    }

    var isValidPassword: Bool {
        // TODO
        return true
    }
}
