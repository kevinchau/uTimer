//
//  CountdownTimerCollectionViewCell.swift
//  uTimer
//
//  Created by Kevin Chau on 12/7/19.
//  Copyright © 2019 Likely Labs. All rights reserved.
//

import UIKit

class CountdownTimerCollectionViewCell: UICollectionViewCell {
    
    var timerIndex: Int!
    var display = UILabel()
    
    
    func loadView() {
        let timer = TimerManager.shared.timers[timerIndex]
        NotificationCenter.default.addObserver(self, selector: #selector(receivePulse), name: .Pulse, object: nil)
        //TODO: need a display, controls, and then how the controls will interact, subscribe to the pulse, get the new time with each pulse.
        
        contentView.backgroundColor = .white
        contentView.addSubview(display)
        display.translatesAutoresizingMaskIntoConstraints = false
        display.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        display.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        display.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        display.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        display.textColor = .black
        display.text = timer.duration.description
        
        
    }
    
    override func prepareForReuse() {
        // unsubscribe from pulse
    }
    
    @objc private func receivePulse() {
        DispatchQueue.main.async {
            self.display.text = TimerManager.shared.timers[self.timerIndex].duration.description
        }
    }
    
    
    
    
    
    
}
