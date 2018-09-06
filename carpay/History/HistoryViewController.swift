//
//  HistoryViewController.swift
//  CarPay
//
//  Created by Luke Newman on 4/4/18.
//  Copyright © 2018 CarPay. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, ManagerConfigurable {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self

            tableView.register(SessionTableViewCell.self, forCellReuseIdentifier: SessionTableViewCell.reuseIdentifier())
        }
    }

    private var managers: Managers?
    fileprivate var sessions: [Session]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "SessionTableViewCell", bundle: nil), forCellReuseIdentifier: SessionTableViewCell.ReuseIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reloadSessions()
    }

    func configure(with managers: Managers) {
        self.managers = managers
    }

    private func reloadSessions() {
        guard let managers = managers else {
            preconditionFailure("Expected to have valid managers")
        }

        let task = managers.session.getSessions()
        tableView.presentHUDDuring(task) { [weak self] result in
            switch result {
            case .success(let sessions):
                self?.sessions = sessions
            case .failure(let error):
                let alert = UIAlertController.errorAlert(with: error)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }

}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SessionTableViewCell.ReuseIdentifier, for: indexPath) as? SessionTableViewCell else {
            preconditionFailure("Expected to dequeue a SessionTableViewCell")
        }
        guard let session = sessions?[indexPath.row] else {
            preconditionFailure("Expected to have a valid session for indexPath \(indexPath)")
        }

        cell.configure(for: session)
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO in the ~ f u t u r e ~
    }
}
