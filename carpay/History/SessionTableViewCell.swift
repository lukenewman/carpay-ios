//
//  SessionTableViewCell.swift
//  carpay
//
//  Created by Luke Newman on 8/2/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {

    static let ReuseIdentifier = "SessionCell"

    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var lotLabel: UILabel!
    @IBOutlet private var plateLabel: UILabel!

    func configure(for session: Session) {
        priceLabel.text = String(describing: session.cost)
        timeLabel.text = "\(session.entry) - \(session.exit)"
        lotLabel.text = String(describing: session.lotID)
        plateLabel.text = session.plate
    }
    
}
