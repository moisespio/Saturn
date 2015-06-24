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
        
        let lblSaturn : UILabel = UILabel(frame: CGRectMake(26, 27, 100, 70))
        lblSaturn.text = "SATURN"
        lblSaturn.backgroundColor = UIColor.redColor()
        
        navigationBarAppearance.addSubview(lblSaturn)
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("8mUWmIYpf3NdgETSQZDBpZ6iWgGylRc7MgU2XWwV",
            clientKey: "j20tqooIvPguQrheOPTx6kYpmuRfOZrbWJzecsWZ")

        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        return true
    }



}

