//
//  SensorsViewController.swift
//  Saturn
//
//  Created by Luis Henrique on 6/24/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class SensorsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSaturnNavigationBarWithMenuButton("tappedMenuButton:")
    }
    
    func tappedMenuButton(sender: UIButton!)
    {
        println("tapped button")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        performSegueWithIdentifier("ScanViewController", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}