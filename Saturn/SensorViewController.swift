//
//  SensorViewController.swift
//  Saturn
//
//  Created by Rodrigo Lungui on 25/06/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class SensorViewController: UIViewController {

    @IBOutlet weak var labelSensorCode: UILabel!
    var sensorCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        labelSensorCode.text = sensorCode
        println(sensorCode)
    }
    
    func tappedCloseButton(sender: UIViewController!) {
        println("Close")
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
