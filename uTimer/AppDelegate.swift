//
//  AppDelegate.swift
//  uTimer
//
//  Created by Kevin Chau on 10/19/19.
//  Copyright © 2019 Likely Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // No Storyboard
        window = UIWindow(frame: UIScreen.main.bounds)
        let v = NavigationController()
        v.setViewControllers([TimerCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())], animated: true)
        window?.rootViewController = v
        window?.makeKeyAndVisible()
        // End No Storyboard
        
        let _ = TimerManager.shared
        return true
    }

}

