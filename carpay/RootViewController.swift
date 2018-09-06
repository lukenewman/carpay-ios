//
//  RootViewController.swift
//  CarPay
//
//  Created by Luke Newman on 4/8/18.
//  Copyright © 2018 CarPay. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet private var containerView: UIView!
    private var containedViewController: UIViewController?

    private let managers = Managers()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentFlow()
    }
    
    private func presentFlow() {
//        presentAuthenticationFlow() // DEBUG

        if managers.authentication.isAuthenticated {
            presentTabBarFlow()
        } else {
//            UserDefaults.standard.hasSeenIntro ? presentAuthenticationFlow() : presentIntroFlow()
            presentAuthenticationFlow()
        }
    }
    
    private func presentTabBarFlow() {
        let mainTabBarController = UIStoryboard.Main.mainTabBarController
        mainTabBarController.configure(with: self, managers: managers)
        swapRoot(to: mainTabBarController)
    }
    
    private func presentAuthenticationFlow() {
        let loginViewController = UIStoryboard.Authentication.rootViewController
        loginViewController.configure(with: self, managers: managers)
        swapRoot(to: loginViewController)
    }
    
    private func presentIntroFlow() {
        let introViewController = UIStoryboard.Intro.rootViewController
        // TODO - will need to inject managers here?
        swapRoot(to: introViewController)
    }
    
    private func swapRoot(to viewController: UIViewController) {
        // Remove existing child view controller
        containedViewController?.willMove(toParentViewController: nil)
        containedViewController?.view.removeFromSuperview()
        containedViewController?.removeFromParentViewController()
        
        // Add child view controller
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            ])
        viewController.didMove(toParentViewController: self)
        containedViewController = viewController
    }

}

// MARK: - AuthenticationCoordinator

protocol AuthenticationCoordinator {
    func didLogIn()
    func onboardingDidFinish()
    func didLogOut()
}

protocol AuthenticationCoordinatorConfigurable {
    func configure(with authCoordinator: AuthenticationCoordinator)
}

extension RootViewController: AuthenticationCoordinator {
    func didLogIn() {
        presentTabBarFlow()
    }

    func onboardingDidFinish() {
        presentTabBarFlow()
    }

    func didLogOut() {
        presentAuthenticationFlow()
    }
}
