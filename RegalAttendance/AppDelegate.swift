//
//  AppDelegate.swift
//  CanlendarTest
//
//  Created by Regal System on 2016/1/22.
//  Copyright © 2016年 Regal System. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Global.rootView = window?.rootViewController
        
        if #available(iOS 10, *){
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.alert,.sound]){(granted,error)in }
            application.registerForRemoteNotifications()
        }
        else if #available(iOS 11, *){
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.alert,.sound]){(granted,error)in }
            application.registerForRemoteNotifications()
        }
        else if #available(iOS 9, *){
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:[.badge,.alert,.sound],categories:nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        else if #available(iOS 8, *){
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:[.badge,.alert,.sound],categories:nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        else if #available(iOS 7, *){
            application.registerForRemoteNotifications(matching:[.badge,.alert,.sound])
            
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let prefs:UserDefaults = UserDefaults.standard
        prefs.set(deviceTokenString, forKey: "deviceToken")
        print("APNs device token:\(deviceTokenString)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed:\(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
    }
}

