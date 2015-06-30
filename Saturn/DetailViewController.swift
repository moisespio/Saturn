//
//  DetailViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/29/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var sensorIdentifier: UILabel!
    @IBOutlet weak var sensorLocation: UILabel!
    
    var sensorNameText = ""
    var sensorLocationText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        
        sensorIdentifier.text = sensorNameText
        sensorLocation.text = sensorLocationText
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tappedCloseButton(sender: UIViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
