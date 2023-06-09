//
//  Timer.swift
//  uTimer
//
//  Created by Kevin Chau on 10/19/19.
//  Copyright © 2019 Likely Labs. All rights reserved.
//


import Foundation
import UserNotifications
import AVFoundation

final class CountdownTimer: Codable {
    private (set) var name: String
    private (set) var initialDuration: Double
    private (set) var duration: Double
    private (set) var endTime: TimeInterval?
    // TODO: notification manager
    private (set) var state: TimerState {
        // Never gets called on initial setting of the property.
        // Opportunity to refactor because of that
        didSet {
            switch state {
            case .new:
                endTime = nil
            case .running:
                endTime = NSDate().timeIntervalSince1970 + duration
            case .ended:
                endTime = nil
            case .paused:
                endTime = nil
            }
            print("didSet")
            TimerManager.shared.notifyChanged(self)
        }
    }
    
    init(name: String, initialDuration: Double, durationSeconds: Double, state: TimerState = .new) {
        // create initializer
        self.name = name
        self.initialDuration = initialDuration
        self.duration = durationSeconds
        self.state = state
        switch state {
        case .new:
            endTime = durationSeconds
        case .running:
            endTime = NSDate().timeIntervalSince1970 + duration
            // TODO: create notification
        case .ended:
            endTime = nil
        case .paused:
            endTime = durationSeconds
        }
        NotificationCenter.default.addObserver(self, selector: #selector(receivePulse), name: .Pulse, object: nil)
    }
    
    init(name: String, initialDuration: Double, endTime: TimeInterval, state: TimerState, duration: Double) {
        print("resume init" + " \(initialDuration)" + " \(endTime)" + " \(state)")
        // restore initializer
        self.name = name
        self.initialDuration = initialDuration
        print(endTime)
        print(NSDate().timeIntervalSince1970)
        // todo: determine what the state should be depending on the remaining duration
        switch state {
        case .running:
            
            if NSDate().timeIntervalSince1970 > endTime {
                self.duration = 0
                self.state = .ended
            } else {
                self.duration = (endTime - NSDate().timeIntervalSince1970).rounded()
                self.state = .running
            }
        case .paused:
            self.duration = duration
            self.state = .paused
        case .ended:
            self.duration = 0
            self.state = .ended
        case .new:
            self.state = .new
            self.duration = initialDuration
            
        }

        NotificationCenter.default.addObserver(self, selector: #selector(receivePulse), name: .Pulse, object: nil)
    }
    
    func startPause() {
        switch state {
        case .paused: let _ = start()
        case .running: let _ = pause()
        default: break
        }
    }
    
    func start() -> Bool {
        // TODO: create notification
        switch state {
        case .new, .paused:
            state = .running
            return true
        default:
            return false
        }
    }
    
    func pause() -> Bool {
        // TODO: remove notification
        switch state {
        case .running:
            state = .paused
            return true
        default:
            return false
        }
    }
    
    func restart() -> Bool {
        // TODO: replace notification
        if state != .new {
            duration = initialDuration
            state = .running
            return true
        }
        return false
    }
    
    func reset() -> Bool {
        // remove notification
        if state != .running || state != .new {
            duration = initialDuration
            state = .new
            return true
        }
        return false
    }
    
    func delete() {
        // delete the timer
        // remove notification
        // notify completion of removal
        // self destruct
    }
    
    func resume() {
        // new duration from resuming
        if let et = endTime {
            endTime = et - NSDate().timeIntervalSince1970
        }
    }
    
    private func end() {
        state = .ended
        // play sound
        AudioServicesPlaySystemSound(SystemSoundID(1325))
    }
    
    @objc private func receivePulse() {
        // TODO: placeholder code
        // the viewcontroller will update itself based on pulse
        // do we trigger the sound from here, or do we let the vc do it?
        // update status based on if the timer has ended.
        if state == .running {
            duration -= 1
            if duration <= 0 {
                duration = 0
                end()
            }
            print(duration)
        }
    }
    
    private func replaceNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = ""
        content.subtitle = ""
        content.body = ""
        // TODO: user customizable sound should go here
        content.sound = UNNotificationSound.default
        // TODO: uncomment identifier to allow custom actions
//        content.categoryIdentifier = timerFinishedCategoryIdentifier
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                // create the notification here
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.duration, repeats: false)
                let request = UNNotificationRequest(identifier: self.name, content: content, trigger: trigger)
                center.add(request) { (error) in
                    if let e = error {
                        // TODO: handle errors
                    }
                }
            }
            else {
                // notify user they need to grant permissions
            }
        }
    }
    
    private func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [name])
    }
}
