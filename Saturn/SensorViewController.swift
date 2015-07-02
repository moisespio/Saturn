//
//  SensorViewController.swift
//  Saturn
//
//  Created by Rodrigo Lungui on 25/06/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import Parse

class SensorViewController: UIViewController {

    @IBOutlet weak var labelSensorCode: UILabel!
    @IBOutlet weak var codeField: UITextField!
    var sensorCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        labelSensorCode.text = sensorCode
    }
    
    override func viewDidAppear(animated: Bool) {
        var border = CALayer()
        var width = CGFloat(2.0)
        border.borderColor = UIColor(red: 222/255, green: 226/255, blue: 233/255, alpha: 1).CGColor
        border.frame = CGRect(x: 0, y: codeField.frame.size.height - width, width:  codeField.frame.size.width, height: codeField.frame.size.height)
        
        border.borderWidth = width
        codeField.layer.addSublayer(border)
        codeField.layer.masksToBounds = true

    }
    
    @IBAction func saveSensor(sender: UIButton) {
        let sensorName = codeField.text
        
        if sensorName == "" || sensorName == nil {
            var alertView:UIAlertView = UIAlertView(title: "Novo Sensor", message:"Você precisa dar um nome a este sensor.", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
            return
        }
        
        let sensor = SensorModel(sensorName: sensorName, sensorCode: sensorCode, sensorDescription: "")
        
        sensor.saveSensor {
            (success: Bool, message: String) -> Void in
            if (success) {
                self.performSegueWithIdentifier("sensorsViewController", sender: nil)
            } else {
                var alertView:UIAlertView = UIAlertView(title: "Desculpe", message:"Algo errado aconteceu. Tente novamente.", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            }
        }

    }
    
    func updateSensor()
    {
        UIView.animateWithDuration(0.5, animations: {
            
        })
    }
    
    func tappedCloseButton(sender: UIViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}