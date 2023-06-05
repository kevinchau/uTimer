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
                let _ = timer.restart()
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
    
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
