//
//  LicensePlateEntryViewController.swift
//  carpay
//
//  Created by Luke Newman on 5/14/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

/*

 TODO

 - disable paste in stateTextField (or figure out a non-UITextField approach)

 */

import UIKit
import Stripe

private struct FormState {
    var number: String?
    var state: State?

    var isValid: Bool {
        return number != nil && state != nil
    }
}

class LicensePlateEntryViewController: UIViewController {

    private var authenticationCoordinator: AuthenticationCoordinator?
    private var managers: Managers?

    fileprivate var formState = FormState()

    // MARK: @IBOutlets

    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = Design.Colors.purple
        }
    }

    @IBOutlet var explanationLabel: UILabel! {
        didSet {
            explanationLabel.textColor = Design.Colors.purple.withAlphaComponent(0.8)
        }
    }

    @IBOutlet private var formWrapperView: UIView! {
        didSet {
            formWrapperView.layer.cornerRadius = Design.VisualConstants.cornerRadius
            formWrapperView.layer.borderWidth = Design.VisualConstants.borderWidth
            formWrapperView.layer.borderColor = Design.Colors.purple.cgColor
        }
    }
    @IBOutlet private var licensePlateTextField: UITextField! {
        didSet {
            licensePlateTextField.autocapitalizationType = .allCharacters
            licensePlateTextField.addTarget(self, action: #selector(formChanged), for: .editingChanged)
        }
    }
    private let statePicker = UIPickerView()
    @IBOutlet private var stateTextField: UITextField! {
        didSet {
//            stateTextField.addTarget(self, action: #selector(formChanged), for: UIControlEvents.)
            statePicker.delegate = self
            stateTextField.inputView = statePicker
        }
    }
    @IBOutlet private var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 6.0
            nextButton.layer.borderColor = Design.Colors.purple.cgColor
            nextButton.layer.borderWidth = 1.0
        }
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Plate Info"

        setStateInputAccessoryView()
    }

    func configure(with coordinator: AuthenticationCoordinator, _ managers: Managers) {
        authenticationCoordinator = coordinator
        self.managers = managers
    }

    // MARK: @IBActions

    @IBAction private func nextButtonTapped(_ sender: Any) {
        guard formState.isValid else {
            preconditionFailure("Next button should not be enabled with invalid FormState")
        }
        guard let number = formState.number, let state = formState.state else {
            preconditionFailure("Expected to have a valid license plate number and state from a valid FormState")
        }
        guard let managers = managers else {
            preconditionFailure("Expected to have valid Managers")
        }

        let plate = number + state.abbrev
        managers.onboarding.onboardingUserDidAdd(plate: plate)

        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        navigationController?.pushViewController(addCardViewController, animated: true)
    }
}

extension LicensePlateEntryViewController: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController.dismiss(animated: true, completion: nil)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        guard let managers = managers else {
            preconditionFailure("Expected to have valid managers when the addCardViewController finished")
        }

        // Notify add card view controller that token creation was handled successfully
        completion(nil)

        managers.onboarding.onboardingUserDidAdd(stripeToken: token.tokenId)
        let task = managers.onboarding.onboardingUserDidFinish()
        addCardViewController.presentHUDDuring(task) { [weak self] result in
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: {
                    self?.authenticationCoordinator?.onboardingDidFinish()
                })
            case .failure(let error):
//                let alert = UIAlertController.errorAlert(with: error)
//                self?.present(alert, animated: true, completion: nil)
                completion(error)
            }
        }

        // Dismiss the current UINavigationController and alert the authenticationCoordinator that onboarding has finished
//        dismiss(animated: true, completion: nil)

//        authenticationCoordinator?.onboardingDidFinish()
    }
}

extension LicensePlateEntryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].pickerTitle
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = states[row].pickerTitle
    }

    private func setStateInputAccessoryView() {
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        accessoryView.backgroundColor = .clear
        accessoryView.translatesAutoresizingMaskIntoConstraints = false

        let doneButton = UIButton(type: .custom)
        doneButton.isEnabled = true
        doneButton.adjustsImageWhenHighlighted = true
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.backgroundColor = .white
        doneButton.setTitle("That one", for: .normal)
        doneButton.setTitleColor(Design.Colors.purple, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        doneButton.addTarget(self, action: #selector(self.stateDoneButtonTapped), for: .touchUpInside)
        accessoryView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: accessoryView.bottomAnchor, constant: -10)
            ])

        stateTextField.inputAccessoryView = accessoryView
    }

    @objc private func stateDoneButtonTapped() {
        let stateIndex = statePicker.selectedRow(inComponent: 0)
        guard stateIndex < states.count else {
            preconditionFailure("Expected a valid stateIndex")
        }

        // Edge case when tapping done button without moving the picker (Alabama folks).
        stateTextField.text = states[stateIndex].pickerTitle

        formState.state = states[stateIndex]

        nextButton.isEnabled = formState.isValid

        stateTextField.resignFirstResponder()
    }
}

// MARK: - UITextField Observer

extension LicensePlateEntryViewController {
    @objc fileprivate func formChanged() {
        guard let plateNumber = licensePlateTextField.text else {
            preconditionFailure("Failed to get text from licensePlateTextField")
        }

        guard plateNumber.isValidLicensePlateNumber else { return }

        formState.number = plateNumber

        nextButton.isEnabled = formState.isValid
    }
}

// MARK: - Form Validation

extension String {
    var isValidLicensePlateNumber: Bool {
        // TODO
        return true
    }
}
