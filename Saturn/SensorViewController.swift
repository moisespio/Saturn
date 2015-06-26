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
    @IBOutlet weak var codeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        labelSensorCode.text = sensorCode
        println(sensorCode)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification)
    }
    
    func animateWithKeyboard(notification: NSNotification) {
        var userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        if notification.name == UIKeyboardWillShowNotification {
//            buyButtonBottomConstraint.constant = keyboardSize.height
//            cameraTopConstraint.constant = (keyboardSize.height - 70) * -1
        }
        else {
//            buyButtonBottomConstraint.constant = 0
//            cameraTopConstraint.constant = 70
        }
        
        view.setNeedsUpdateConstraints()
        let options = UIViewAnimationOptions(curve << 16)
        
        UIView.animateWithDuration(duration, delay: 0, options: options,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
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
