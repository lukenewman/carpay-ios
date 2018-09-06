//
//  HUDViewController.swift
//  carpay
//
//  Created by Luke Newman on 7/31/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import UIKit
import Deferred

final private class HUDViewController: UIViewController {

    private enum Constants {
        static let hudCornerRadius: CGFloat = 10
        static let marginInset: CGFloat = 20
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear

        let hud = HUDView()
        view.addSubview(hud)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: hud.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: hud.centerYAnchor)
            ])
    }

}

final private class HUDView: UIView {
    private enum Constants {
        static let hudCornerRadius: CGFloat = 10
        static let marginInset: CGFloat = 20
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        layer.cornerRadius = Constants.hudCornerRadius
        let inset = Constants.marginInset
        layoutMargins = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.activityIndicatorViewStyle = .white
        activityIndicator.startAnimating()

        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            layoutMarginsGuide.leadingAnchor.constraint(equalTo: activityIndicator.leadingAnchor),
            layoutMarginsGuide.trailingAnchor.constraint(equalTo: activityIndicator.trailingAnchor),
            layoutMarginsGuide.topAnchor.constraint(equalTo: activityIndicator.topAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: activityIndicator.bottomAnchor)
            ])
    }
}

extension UIViewController {
    func presentHUDDuring<F: FutureProtocol>(_ future: F, completion: ((F.Value) -> Void)? = nil) {
        let hud = HUDViewController()
        present(hud, animated: true) {
            future.upon(DispatchQueue.main) { result in
                hud.dismiss(animated: false) {
                    completion?(result)
                }
            }
        }
    }
}

extension UITableView {
    func presentHUDDuring<F: FutureProtocol>(_ future: F, completion: ((F.Value) -> Void)? = nil) {
        let hud = HUDView()
        addSubview(hud)
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: hud.centerXAnchor),
            centerYAnchor.constraint(equalTo: hud.centerYAnchor)
            ])
        future.upon(DispatchQueue.main) { result in
            hud.removeFromSuperview()
            completion?(result)
        }
    }
}
