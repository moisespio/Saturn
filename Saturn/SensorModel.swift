//
//  SensorModel.swift
//  Saturn
//
//  Created by Luis Henrique on 6/25/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import Parse

class SensorModel: NSObject {
    
    init(sensorParseObject : PFObject)
    {
        self.sensorParseObject = sensorParseObject
        self.sensorCode = sensorParseObject["code"] as? String
        self.sensorName = sensorParseObject["name"] as? String
        self.sensorDescription = sensorParseObject["description"] as? String
    }
    
    var sensorParseObject : PFObject?
    var sensorCode : String?
    var sensorName : String?
    var sensorDescription : String?
    
    ///
    /// Usage:
    ///
    ///     let sensor = SensorModel()
    ///     sensor.sensorCode = "123456"
    ///     sensor.sensorName = "Casa"
    ///     sensor.sensorDescription = "Rua da Tristeza, 22"
    ///     sensor.saveSensor{
    ///         (success: Bool, message: String) -> Void in
    ///             if (success) {
    ///                 self.dismissViewControllerAnimated(true, completion: nil)
    ///             } else {
    ///                 var alert = UIAlertController(title: "Erro", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    ///                 alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    ///                 self.presentViewController(alert, animated: true, completion: nil)
    ///             }
    ///     }
    func saveSensor(function: (Bool, String) -> Void) -> Void
    {
        let sensor = PFObject(className:"Sensor")
        sensor["code"] = sensorCode
        sensor["name"] = sensorName
        sensor["description"] = sensorDescription
        sensor["installation"] = PFInstallation.currentInstallation()
        sensor.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                function(true, "")
            } else {
                print(error!.description)
                function(false, error!.description)
            }
        }
    }
    
    ///
    /// Usage:
    ///         SensorModel.getSensors {
    ///             (sensorList: Array<SensorModel>?) -> Void in
    ///                 if (sensorList != nil) {
    ///                     //your code here
    ///                 }
    ///        }
    static func getSensors(function: (Array<SensorModel>?) -> Void) -> Void
    {
        var query = PFQuery(className:"Sensor")
        query.whereKey("installation", equalTo:PFInstallation.currentInstallation().objectId!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            var sensorList = Array<SensorModel>()
            if (error == nil) {
                println("Successfully retrieved \(objects!.count) sensors.")
                if let sensors = objects as? [PFObject] {
                    for sensor in sensors {
                        let sensorModel = SensorModel(sensorParseObject: sensor)
                        sensorList.append(sensorModel)
                    }
                }
                function(sensorList)
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
                function(nil)
            }
        }
        
    }
    
}
