//
//  AppDelegate.swift
//  Softgames Test
//
//  Created by Hamza Khan on 19/02/2022.
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
            if granted {
                print("User gave permissions for local notifications")
            }
        }
        
        return true
    }

    
    //MARK:- UNUSerNotificationDelegates

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Usrinfo associated with notification == \(response.notification.request.content.userInfo)")
        
        completionHandler()
    }


}

