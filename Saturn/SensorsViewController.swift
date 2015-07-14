//
//  SensorsViewController.swift
//  Saturn
//
//  Created by Luis Henrique on 6/24/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class SensorsViewController: UIViewController, AVSpeechSynthesizerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var items: [SensorModel] = []
    var selectedRow = 0
    var firstTime = true
    var sensorGasLevelIcon = [
        "big-ok-icon",
        "big-warning-icon",
        "big-danger-icon"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        updateSensors()
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("updateSensors"), userInfo: nil, repeats: true)
        
        SensorModel.getSensors {
            (sensorList: Array<SensorModel>?) -> Void in
            if (sensorList != nil) {
                var sensors: [SensorModel] = []
                var speechStr = "Sensors Listing. No leak detected."

                sensors = sensorList!
                
                for var index = 0; index < sensors.count; ++index {
                    if (sensors[index].sensorStatus > 0) {
                        speechStr = "Sensors Listing. A leak was detected"
                    }
                }
                
                let speechSynthesizer = AVSpeechSynthesizer()
                
                let speechUtterance = AVSpeechUtterance(string: speechStr)
                
                speechUtterance.rate = 0.1
                speechUtterance.pitchMultiplier = 1
                speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                
                speechSynthesizer.speakUtterance(speechUtterance)
            }
        }
    }
    
    func updateSensors(){
        println("udpateSensors")
        SensorModel.getSensors {
            (sensorList: Array<SensorModel>?) -> Void in
            if (sensorList != nil) {
                self.items = sensorList!
                self.tableView.reloadData()
                
                if ((self.items.count == 1) && (self.firstTime)){
                    self.firstTime = false
                    self.selectedRow = 0
                    self.performSegueWithIdentifier("DetailViewController", sender: nil)
                }
            }
        }
    }
    
    func tappedMenuButton(sender: UIButton!) {
        self.slideMenuController()?.openRight()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addSaturnNavigationBarWithMenuButton("tappedMenuButton:")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SensorsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! SensorsTableViewCell
        cell.identifier.text = self.items[indexPath.row].sensorName
        cell.location.text = self.items[indexPath.row].sensorDescription
        cell.statusIcon.image = UIImage(named: sensorGasLevelIcon[self.items[indexPath.row].sensorStatus])
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        performSegueWithIdentifier("DetailViewController", sender: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let tv = self.tableView {
                var alert = UIAlertController(title: "Delete Sensor", message: "Do you really want to delete this sensor?", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { action in
                    var sensor: PFObject = self.items[indexPath.row].sensorParseObject!
                    sensor.deleteInBackground()
                    self.items.removeAtIndex(indexPath.row)
                    tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController: DetailViewController = segue.destinationViewController as? DetailViewController {
            
            detailViewController.sensorNameText = items[selectedRow].sensorName!
            detailViewController.sensorLocationText = items[selectedRow].sensorDescription!
            detailViewController.sensorStatus = items[selectedRow].sensorStatus
            detailViewController.sensorObjectId = items[selectedRow].sensorParseObject!.objectId!
        }
    }
}