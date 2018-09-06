//
//  MainTabBarController.swift
//  CarPay
//
//  Created by Luke Newman on 4/8/18.
//  Copyright © 2018 CarPay. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = Design.Colors.red
        UITabBar.appearance().barStyle = .blackOpaque
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = Design.Colors.red
        UINavigationBar.appearance().barStyle = .blackOpaque
        let titleTextAttributes = [ NSAttributedStringKey.foregroundColor: Design.Colors.red ]
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
    }

    func configure(with authCoordinator: AuthenticationCoordinator, managers: Managers) {
        viewControllers?.forEach {
            guard let navigationController = $0 as? UINavigationController else {
                return
            }

            if let viewController = navigationController.topViewController {
                if let managerConfigurable = viewController as? ManagerConfigurable {
                    managerConfigurable.configure(with: managers)
                }
                if let authCoordinatorConfigurable = viewController as? AuthenticationCoordinatorConfigurable {
                    authCoordinatorConfigurable.configure(with: authCoordinator)
                }
            }
        }
    }

}
