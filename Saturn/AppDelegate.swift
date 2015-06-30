//
//  AppDelegate.swift
//  Saturn
//
//  Created by Moisés Pio on 6/22/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor(red: 127/255, green: 148/255, blue: 255/255, alpha: 1.0)
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("8mUWmIYpf3NdgETSQZDBpZ6iWgGylRc7MgU2XWwV",
            clientKey: "j20tqooIvPguQrheOPTx6kYpmuRfOZrbWJzecsWZ")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        var type = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
        var setting = UIUserNotificationSettings(forTypes: type, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("SensorsViewController") as! SensorsViewController
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        
        let slideMenuController = SlideMenuController(mainViewController: mainViewController, rightMenuViewController: rightViewController)
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
        //printFonts()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("Register: \(deviceToken)")
        PFInstallation.currentInstallation().setDeviceTokenFromData(deviceToken)
        PFInstallation.currentInstallation().saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Couldn't register: \(error)")
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        var array = NSMutableArray()
        var retValues = NSMutableDictionary()
        retValues.setValue(array, forKey: "SENSORS")

        if let sensorList = SensorModel.getSensorsSync()
        {
            for sensor in sensorList {
                var dic = NSMutableDictionary()
                dic.setValue(sensor.sensorName, forKey: "SENSOR_NAME")
                dic.setValue(sensor.sensorStatus, forKey: "SENSOR_STATUS")
                array.addObject(dic)
            }
            
            reply(retValues as [NSObject : AnyObject])
        }
        else
        {
            reply([:])
        }
    }
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            println("------------------------------")
            println("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName as! String)
            println("Font Names = [\(names)]")
        }
    }
    
    
}

