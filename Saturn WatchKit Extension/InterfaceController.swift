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
                sensorRow.imgStatus.setImage(UIImage(named: "small-ok-icon"))
            case 1:
                sensorRow.imgStatus.setImage(UIImage(named: "small-warning-icon"))
            case 2:
                sensorRow.imgStatus.setImage(UIImage(named: "small-problem-icon"))
            default:
                sensorRow.imgStatus.setImage(UIImage(named: "small-ok-icon"))
            }
        }
    }
    
    func loadSensorList (){
        var dic = NSDictionary(object: "querySensors", forKey: "ACTION")
        
//        WKInterfaceController.openParentApplication(dic, reply: { ([NSObject : AnyObject]!, NSError!) -> Void in
//            
//        })
    }
    
}
