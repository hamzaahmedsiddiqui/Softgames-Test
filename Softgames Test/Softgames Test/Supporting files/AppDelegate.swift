//
//  AppDelegate.swift
//  Softgames Test
//
//  Created by Hamza Ahmed on 19/02/2022.
//

import UIKit
@main

class AppDelegate: UIResponder,
                    UIApplicationDelegate,
                    UNUserNotificationCenterDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if !granted {
                /*
                 Here we can handle this by creating a popup for the user to give permission for the app.
                 */
                print("User didn't give permissions for local notifications")
            }
        }
        
        return true
    }

    
    //MARK:- UNUSerNotificationDelegates

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

