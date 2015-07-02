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
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var gasLevelLabel: UILabel!
    
    var sensorStatus = 0
    var sensorNameText = ""
    var sensorLocationText = ""
    var sensorGasLevelIcon = [
        "big-ok-icon",
        "big-warning-icon",
        "big-danger-icon"
    ]
    
    var sensorGasLevelLabel = [
        "Nenhum vazamento detectado",
        "Pequeno vazamento detectado",
        "Grande vazamento detectado"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        
        sensorIdentifier.text = sensorNameText
        sensorLocation.text = sensorLocationText
        
        self.icon.image = UIImage(named: sensorGasLevelIcon[sensorStatus])
        self.gasLevelLabel.text = sensorGasLevelLabel[sensorStatus]
        
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
