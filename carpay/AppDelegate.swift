//
//  AppDelegate.swift
//  CarPay
//
//  Created by Greg Krathwohl on 7/24/17.
//  Copyright © 2017 CarPay LLC. All rights reserved.
//

import UIKit
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        STPPaymentConfiguration.shared().publishableKey = "pk_test_BSHAKdpcYXK0cLOSy3wZZ5Ka"
        STPTheme.default().accentColor = Design.Colors.purple

        UINavigationBar.appearance().tintColor = Design.Colors.purple

        return true
    }
    
}
