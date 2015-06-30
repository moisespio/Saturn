//
//  SensorsViewController.swift
//  Saturn
//
//  Created by Luis Henrique on 6/24/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import Parse

class SensorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var items: [SensorModel] = []
    var selectedRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        SensorModel.getSensors {
            (sensorList: Array<SensorModel>?) -> Void in
            if (sensorList != nil) {
                self.items = sensorList!
                self.tableView.reloadData()
            }
        }

//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSaturnNavigationBarWithMenuButton("tappedMenuButton:")
    }
    
    func tappedMenuButton(sender: UIButton!)
    {
        self.slideMenuController()?.openRight()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        performSegueWithIdentifier("ScanViewController", sender: nil)
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
                var sensor: PFObject = self.items[indexPath.row].sensorParseObject!
                sensor.deleteInBackground()
                items.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailViewController: DetailViewController = segue.destinationViewController as? DetailViewController {
            
            detailViewController.sensorNameText = items[selectedRow].sensorName!
            detailViewController.sensorLocationText = items[selectedRow].sensorDescription!
        }
    }
}