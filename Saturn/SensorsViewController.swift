//
//  SensorsViewController.swift
//  Saturn
//
//  Created by Luis Henrique on 6/24/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class SensorsViewController: UIViewController {

    let navBar:UINavigationBar = UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        navBar.frame=CGRectMake(0, 0, self.view.frame.size.width, 70)
        self.view.addSubview(navBar)
        
        let menuButton : UIButton = UIButton(frame: CGRectMake(self.view.frame.width-85, 0, 60, 65))
        menuButton.setImage(UIImage(named: "menuButton"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "tappedMenuButton:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(menuButton)
        
        let lblSaturn : UILabel = UILabel(frame: CGRectMake(26, 0, 100, 60))
        lblSaturn.font = UIFont(name: "SanFranciscoText-Semibold", size: 14)
        lblSaturn.text = "S A T U R N"
        lblSaturn.textColor = UIColor.whiteColor()
        navBar.addSubview(lblSaturn)
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
