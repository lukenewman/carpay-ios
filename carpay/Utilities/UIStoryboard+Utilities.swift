//
//  UIStoryboard+Utilities.swift
//  CarPay
//
//  Created by Luke Newman on 4/8/18.
//  Copyright © 2018 CarPay. All rights reserved.
//

import UIKit

private extension UIStoryboard {
    
    func instantiateViewController<T>(ofType type: T.Type, withIdentifier identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: type)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            preconditionFailure("Expected view controller with identifier \(identifier) to be of type \(type)")
        }
        return viewController
    }
    
    func instantiateInitialViewController<T>(ofType type: T.Type) -> T {
        guard let viewController = instantiateInitialViewController() as? T else {
            preconditionFailure("Expected initial view controller to be of type \(type)")
        }
        return viewController
    }
    
}

extension UIStoryboard {
    private static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    enum Main {
        static var mainTabBarController: MainTabBarController {
            return UIStoryboard.main.instantiateViewController(ofType: MainTabBarController.self,
                                                               withIdentifier: "MainTabBarController")
        }
    }
}

extension UIStoryboard {
    private static var authentication: UIStoryboard {
        return UIStoryboard(name: "Authentication", bundle: nil)
    }

    enum Authentication {
        static var rootViewController: LoginViewController {
            return UIStoryboard.authentication.instantiateInitialViewController(ofType: LoginViewController.self)
        }

        static var onboardingNavigationController: UINavigationController {
            return UIStoryboard.authentication.instantiateViewController(ofType: UINavigationController.self,
                                                               withIdentifier: "OnboardingNavigationController")
        }
    }
}

extension UIStoryboard {
    private static var intro: UIStoryboard {
        return UIStoryboard(name: "Intro", bundle: nil)
    }
    
    enum Intro {
        static var rootViewController: PageViewController {
            return UIStoryboard.intro.instantiateInitialViewController(ofType: PageViewController.self)
        }
    }
}
