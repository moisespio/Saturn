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
        
        //printFonts()
        
        return true
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

