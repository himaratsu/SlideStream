//
//  AppDelegate.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import Parse
import HandShake

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.tintColor = UIColor.color(0x4aa3df)
        setUpApiKey()
        setUpHandShake()
        application.registerForRemoteNotifications()
        return true
    }
    
    private func setUpApiKey() {
        let appID = ""
        let clientKey = ""
        Parse.setApplicationId(appID, clientKey: clientKey)
    }

    private func setUpHandShake() {
        HandShake.setApiKey("")
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (isSuccess, error) -> Void in
            if let error = error {
                print("device token save failed: \(error)")
            } else {
                print("device token registerd")
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("device token get failed: \(error)")
    }

}

