//
//  NewTimerViewController.swift
//  uTimer
//
//  Created by Kevin Chau on 1/21/20.
//  Copyright © 2020 Likely Labs. All rights reserved.
//

import UIKit

protocol NewTimerDelegate: UIViewController {
    func timerAdded()
}

class NewTimerViewController: UIViewController {
    
    var delegate: NewTimerDelegate?
    var picker = UIDatePicker()
    var startButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.setRightBarButton(rightButton, animated: true)
        navigationItem.setLeftBarButton(leftButton, animated: true)

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        picker.datePickerMode = .countDownTimer
        picker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Todo: Change DONE button to Start
        // Todo: Add start button at bottom
        // Todo: Hook up everything
        // Todo: make sure collection view knows how to react
        // Todo: make sure timers get saved
        
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func done() {
        TimerManager.shared.createTimer(name: "Test Timer", initialDuration: picker.countDownDuration, state: .running)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func timePickerChanged() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
