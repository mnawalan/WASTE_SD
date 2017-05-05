//
//  AppDelegate.swift
//  3-20-client
//
//  Created by Mary Kate Nawalaniec on 3/20/17.
//  Copyright © 2017 Mary Kate Nawalaniec. All rights reserved.
//

import UIKit
import Moscapsule
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var controller = SensorTableViewController()
    static var initialized = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.set(false, forKey: "connected")
        UserDefaults.standard.set(false, forKey: "initialized")
        UserDefaults.standard.set("senior-mqtt.esc.nd.edu", forKey: "MQTTHost")
        let userinfo = UserDefaults.standard.bool(forKey: "connected")
        print("TRYING TO SET: ", userinfo.description)
        
        
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
//        if let vc = self.window?.rootViewController as? UIViewController! {
//            let controllers = vc.childViewControllers
//            for viewController in controllers {
//                if let sensorTableController = viewController as? SensorTableViewController {
//                    //call functions in sensor table controller to update in background
//                    sensorTableController.initializeMQTT()
//                }
//            }
//        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
        
    
    
    
    
}

