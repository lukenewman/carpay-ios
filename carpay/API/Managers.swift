//
//  Managers.swift
//  carpay
//
//  Created by Luke Newman on 7/28/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation

struct Managers {
    let authentication = AuthenticationManager()
    let onboarding = OnboardingManager()
    let session = SessionManager()
}

protocol ManagerConfigurable {
    func configure(with managers: Managers)
}
