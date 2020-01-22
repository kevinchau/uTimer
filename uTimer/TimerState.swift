//
//  TimerState.swift
//  uTimer
//
//  Created by Kevin Chau on 10/19/19.
//  Copyright © 2019 Likely Labs. All rights reserved.
//

import Foundation

enum TimerState: String, Codable {
    case new, running, paused, ended
}
