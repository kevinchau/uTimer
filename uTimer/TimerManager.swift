//
//  TimerManager.swift
//  uTimer
//
//  Created by Kevin Chau on 10/19/19.
//  Copyright © 2019 Likely Labs. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension Notification.Name {
    public static let Pulse = Notification.Name("Pulse")
    public static let Update = Notification.Name("Update")
}

class TimerManager {
    static let shared = TimerManager()
    
    private var pulse: Timer!
    
    private (set) var timers: [CountdownTimer] = []
    
    // There will be an app-wide pulse that objects will subscribe to, views will subscribe to it to know when to fetch the updated time, timers will increment their countdowns

    private init() {
        // TODO: the only time this would be called is if the app was killed and we are starting fresh. So in the init, we need to retrieve the existing timers from user defaults, and create timer objects.
        // we need to subscribe to notification for application enters background and will enter foreground here
        
        NotificationCenter.default.addObserver(self, selector: #selector(backgrounded), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resume), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setupNotificationCategories()
        
        resume()
    }
    
    // We should write a wrapper for UserDefaults so that we can write/read in a single threaded fashion.
    
    @objc private func backgrounded() {
        // since the user will not have control of the timers in the background state, we should take all of the timers and encode them to json, and store them in userdefaults
        
        // stop the pulse
        pulse.invalidate()
        
        // testing:
        do {
            if let string = try encodeToJson(timers) {
                print("backgrounded: " + string)
                UserDefaults.standard.set(string, forKey: "timers")
            }
        } catch {
            print(error)
        }
        
    }
    
    @objc private func resume() {
        // opposite of backgrounded(), when the user resumes, the times need to be retrieved from user defaults, and all of the timers should be replaced with new objects in the same order as userdefaults.
        // This is because we do not get notified when the app is killed from background running, no background time is guaranteed
        // Also, every time a single timer state is changed, we need to update our userdefaults.
        // new pulse:
        pulse = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendPulse), userInfo: nil, repeats: true)
        RunLoop.main.add(pulse, forMode: .common)
        timers.removeAll()
        //testing:
        do {
            if let string = UserDefaults.standard.string(forKey: "timers") {
                do {
                    if let storedTimers = try decodeFromJsonString(string) {
                        print("resumed: " + string)
                        
                        for timer in storedTimers {
                            let restoredTimer = CountdownTimer(name: timer.name, initialDuration: timer.initialDuration, endTime: timer.endTime ?? NSDate().timeIntervalSince1970, state: timer.state)
                            timers.append(restoredTimer)
                        }
                        
                    }
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    private func setupNotificationCategories() {
        // TODO: custom actions for notification
        
    }
    
    func notifyChanged(_ timer: CountdownTimer) {
        print("notify changed")
        NotificationCenter.default.post(name: .Update, object: nil)
        do {
            guard let json = try encodeToJson(timers) else { print("Error in notifyChanged"); return }
            print(json)
        } catch {
            print("Error in notifyChanged: \(error)")
        }
        
        // todo: store the timers everytime something changed.
        // testing:
        do {
            if let string = try encodeToJson(timers) {
                print("backgrounded: " + string)
                UserDefaults.standard.set(string, forKey: "timers")
            }
        } catch {
            print(error)
        }
    }
    
    @objc private func sendPulse() {
        // Sends the second pulse that everything in the app will subscribe to
        NotificationCenter.default.post(name: .Pulse, object: nil)
        print("pulse")
    }
    
    // what should we be able to do here?
    // 1: create new timers
    func createTimer(name: String, initialDuration: Double, state: TimerState) -> CountdownTimer {
        let timer = CountdownTimer(name: name, initialDuration: initialDuration, durationSeconds: initialDuration, state: state)
        timers.append(timer)
        notifyChanged(timer)
        return timer
    }
    // 2: rearrange timers
    // 3: get a reference to all timers
    // 4: delete timers
    func deleteTimer(index: Int) {
        let timer = timers[index]
        DispatchQueue.main.async {
            timer.delete()
            self.timers.remove(at: index)
            self.notifyChanged(timer)
        }
        
    }
    // actual timer functions should be controlling the timer directly
    
    private func encodeToJson(_ codableArray: [CountdownTimer]) throws -> String? {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(codableArray)
            return String(data: data, encoding: .utf8)
        }
        catch {
            print("Error in encodeToJson: \(error)")
        }
        return nil
    }
    
    private func decodeFromJsonString(_ json: String) throws -> [CountdownTimer]? {
        let jsonDecoder = JSONDecoder()
        do {
            let data = json.data(using: .utf8)!
            let timers = try jsonDecoder.decode([CountdownTimer].self, from: data)
            return timers
        }
        catch {
            print("Error in decodeFromJsonString: \(error)")
        }
        return nil
    }
}


