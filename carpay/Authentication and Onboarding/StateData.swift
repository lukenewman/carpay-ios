//
//  StateData.swift
//  carpay
//
//  Created by Luke Newman on 5/18/18.
//  Copyright © 2018 CarPay LLC. All rights reserved.
//

import Foundation

public struct State {
    var name: String
    var abbrev: String
    var pickerTitle: String {
        return name + " - " + abbrev
    }
}

public let states: [State] = [
    State(name: "Alabama", abbrev: "AL"),
    State(name: "Alaska", abbrev: "AK"),
    State(name: "Arizona", abbrev: "AZ"),
    State(name: "Arkansas", abbrev: "AR"),
    State(name: "California", abbrev: "CA"),
    State(name: "Colorado", abbrev: "CO"),
    State(name: "Connecticut", abbrev: "CT"),
    State(name: "Delaware", abbrev: "DE"),
    State(name: "Florida", abbrev: "FL"),
    State(name: "Georgia", abbrev: "GA"),
    State(name: "Hawaii", abbrev: "HI"),
    State(name: "Idaho", abbrev: "ID"),
    State(name: "Illinois", abbrev: "IL"),
    State(name: "Indiana", abbrev: "IN"),
    State(name: "Iowa", abbrev: "IA"),
    State(name: "Kansas", abbrev: "KS"),
    State(name: "Kentucky", abbrev: "KY"),
    State(name: "Louisiana", abbrev: "LA"),
    State(name: "Maine", abbrev: "ME"),
    State(name: "Maryland", abbrev: "MD"),
    State(name: "Massachusetts", abbrev: "MA"),
    State(name: "Michigan", abbrev: "MI"),
    State(name: "Minnesota", abbrev: "MN"),
    State(name: "Mississippi", abbrev: "MS"),
    State(name: "Missouri", abbrev: "MO"),
    State(name: "Montana", abbrev: "MT"),
    State(name: "Nebraska", abbrev: "NE"),
    State(name: "Nevada", abbrev: "NV"),
    State(name: "New Hampshire", abbrev: "NH"),
    State(name: "New Jersey", abbrev: "NJ"),
    State(name: "New Mexico", abbrev: "NM"),
    State(name: "New York", abbrev: "NY"),
    State(name: "North Carolina", abbrev: "NC"),
    State(name: "North Dakota", abbrev: "ND"),
    State(name: "Ohio", abbrev: "OH"),
    State(name: "Oklahoma", abbrev: "OK"),
    State(name: "Oregon", abbrev: "OR"),
    State(name: "Pennsylvania", abbrev: "PA"),
    State(name: "Rhode Island", abbrev: "RI"),
    State(name: "South Carolina", abbrev: "SC"),
    State(name: "South Dakota", abbrev: "SD"),
    State(name: "Tennessee", abbrev: "TN"),
    State(name: "Texas", abbrev: "TX"),
    State(name: "Utah", abbrev: "UT"),
    State(name: "Vermont", abbrev: "VT"),
    State(name: "Virginia", abbrev: "VA"),
    State(name: "Washington", abbrev: "WA"),
    State(name: "West Virginia", abbrev: "WV"),
    State(name: "Wisconsin", abbrev: "WI"),
    State(name: "Wyoming", abbrev: "WY"),
]
