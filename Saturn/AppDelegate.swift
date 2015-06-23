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

        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("8mUWmIYpf3NdgETSQZDBpZ6iWgGylRc7MgU2XWwV",
            clientKey: "j20tqooIvPguQrheOPTx6kYpmuRfOZrbWJzecsWZ")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        return true
    }



}

