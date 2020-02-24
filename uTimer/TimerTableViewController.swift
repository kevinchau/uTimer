//
//  TimerCollectionViewController.swift
//  uTimer
//
//  Created by Kevin Chau on 10/21/19.
//  Copyright © 2019 Likely Labs. All rights reserved.
//

import UIKit

// TODO: A view to create timers, controls for the cell

private let reuseIdentifier = "Cell"


class TimerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .Update, object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.tableView!.register(CountdownTimerTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // set row height
        self.tableView!.rowHeight = 50

        // Do any additional setup after loading the view.
        title = "Timers"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTimer))
        navigationItem.setRightBarButton(rightButton, animated: true)
        
        // test, delete
//        let _ = TimerManager.shared.createTimer(name: "test timer", initialDuration: 60, state: .running)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimerManager.shared.timers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let timerCell = cell as? CountdownTimerTableViewCell {
            timerCell.timerIndex = indexPath.row
            timerCell.loadView()
            return timerCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            TimerManager.shared.deleteTimer(index: indexPath.row)
            completionHandler(true)
        }
        
        action.backgroundColor = .red
        action.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    @objc private func addTimer() {
        let vc = UINavigationController()
        let vc2 = NewTimerViewController()
        vc2.delegate = self
        vc.setViewControllers([vc2], animated: true)
        vc2.title = "New Timer"
        present(vc, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension TimerTableViewController: NewTimerDelegate {
    func timerAdded() {
        return
    }
    
    
}
