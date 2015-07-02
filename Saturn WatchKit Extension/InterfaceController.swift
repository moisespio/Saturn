//
//  InterfaceController.swift
//  Saturn WatchKit Extension
//
//  Created by Luis Henrique on 6/29/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var sensorList : Array<SensorModel> = []
    @IBOutlet weak var sensorTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        loadSensorList()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func configureTable(){
        
        self.sensorTable.setNumberOfRows(self.sensorList.count, withRowType: "SensorRowType")
        
        for var index = 0; index < sensorTable.numberOfRows; index++ {
            var sensorRow = sensorTable.rowControllerAtIndex(index) as! SensorRowType
            sensorRow.lblSensor.setText(sensorList[index].sensorName)
            
            switch sensorList[index].sensorStatus {
            case 0:
                sensorRow.imgStatus.setImage(UIImage(named: "big-ok-icon"))
            case 1:
                sensorRow.imgStatus.setImage(UIImage(named: "big-warning-icon"))
            case 2:
                sensorRow.imgStatus.setImage(UIImage(named: "big-danger-icon"))
            default:
                sensorRow.imgStatus.setImage(UIImage(named: "big-ok-icon"))
            }
        }
    }
    
    func loadSensorList(){
        
        var dic = NSDictionary(object: "querySensors", forKey: "ACTION")
        
        WKInterfaceController.openParentApplication(dic as [NSObject : AnyObject], reply: { (replyValues, error) -> Void in
            
            if (replyValues == nil)
            {
                return;
            }
            
            if let sensors = replyValues["SENSORS"] as? NSArray
            {
                for dic in sensors{
                    let m = SensorModel()
                    m.sensorName = dic["SENSOR_NAME"] as? String
                    m.sensorStatus = dic["SENSOR_STATUS"] as! Int
                    self.sensorList.append(m)
                }
                self.configureTable()
            }
        })
    }
    
}
