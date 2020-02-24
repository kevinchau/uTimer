//
//  CountdownTimerCollectionViewCell.swift
//  uTimer
//
//  Created by Kevin Chau on 12/7/19.
//  Copyright © 2019 Likely Labs. All rights reserved.
//

import UIKit

class CountdownTimerTableViewCell: UITableViewCell {
    
    var timerIndex: Int! {
        didSet {
            currentState = TimerManager.shared.timers[exist: timerIndex]?.state
        }
    }
    var display = UILabel()
    var currentState: TimerState? {
        didSet {
            if currentState != oldValue {
               buttonSetup()
            }
        }
    }
    
    private let startPauseButton = UIButton()
    private let resetButton = UIButton()
    
    
    func loadView() {
        let timer = TimerManager.shared.timers[timerIndex]
        NotificationCenter.default.addObserver(self, selector: #selector(receivePulse), name: .Pulse, object: nil)
        //TODO: need a display, controls, and then how the controls will interact, subscribe to the pulse, get the new time with each pulse.
        
        contentView.backgroundColor = .white
        contentView.addSubview(display)
        display.translatesAutoresizingMaskIntoConstraints = false
        display.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        display.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        display.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        display.textColor = .black
        display.text = timer.duration.description
        
        contentView.addSubview(startPauseButton)
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        startPauseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        startPauseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startPauseButton.widthAnchor.constraint(equalTo: startPauseButton.heightAnchor, multiplier: 1.0).isActive = true
        startPauseButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        startPauseButton.setTitleColor(.white, for: .normal)
        startPauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        startPauseButton.layer.cornerRadius = 0.5 * 40
        startPauseButton.clipsToBounds = true
        startPauseButton.addTarget(self, action: #selector(startPauseAction), for: .touchUpInside)
        buttonSetup()
        
        /*
         timerButton.translatesAutoresizingMaskIntoConstraints = false
         timerButton.topAnchor.constraint(lessThanOrEqualTo: timePicker.bottomAnchor, constant: 20).isActive = true
         timerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         timerButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
         timerButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
         if #available(iOS 11.0, *) {
             timerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -78).isActive = true
         } else {
             timerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -78).isActive = true
         }
         timerButton.layer.cornerRadius = 0.5 * buttonSize
         timerButton.setTitleColor(UIColor.white, for: .normal)
         timerButton.clipsToBounds = true
         timerButton.addTarget(self, action: #selector(timerToggle), for: .touchUpInside)
         */
        
        
    }
    
    override func prepareForReuse() {
        // unsubscribe from pulse
    }
    
    @objc private func receivePulse() {
        DispatchQueue.main.async {
            if let description = TimerManager.shared.timers[exist: self.timerIndex]?.duration.description {
                self.display.text = description
            }
            
        }
    }
    
    @objc private func startPauseAction() {
        if let timer = TimerManager.shared.timers[exist: timerIndex] {
            switch timer.state {
            case .running, .paused:
                timer.startPause()
            case .ended:
                timer.restart()
            default: break
            }
        }
    }
    
    private func buttonSetup() {
        DispatchQueue.main.async {
            if let timer = TimerManager.shared.timers[exist: self.timerIndex] {
                switch timer.state {
                case .running:
                    self.startPauseButton.backgroundColor = UIColor.red
                    self.startPauseButton.setTitle("Pause", for: .normal)
                case .paused:
                    self.startPauseButton.backgroundColor = UIColor.green
                    self.startPauseButton.setTitle("Resume", for: .normal)
                case .new: break
                case .ended:
                    self.startPauseButton.backgroundColor = UIColor.blue
                    self.startPauseButton.setTitle("Restart", for: .normal)
                }
            }
        }
    }
    
    /*
    private func buttonSetup() {
        if sleepTimer.timerIsRunning == false {
            timerButton.backgroundColor = UIColor(red: 0.554, green: 0.785, blue: 0.215, alpha: 1.0)
            timerButton.setTitle(NSLocalizedString("Sleep", comment: "Sleep Button"), for: .normal)
        }
        else {
            timerButton.backgroundColor = UIColor(red: 1.0, green: 0.587, blue: 0.325, alpha: 1.0)
            timerButton.setTitle(NSLocalizedString("Cancel", comment: "Sleep Button"), for: .normal)
        }
    }
 */
    
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
