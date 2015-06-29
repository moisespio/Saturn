//
//  SensorsViewController.swift
//  Saturn
//
//  Created by Luis Henrique on 6/24/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class SensorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var items: [SensorModel] = []

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
        println("tapped button")
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
        cell.identifier.text = self.items[indexPath.row].sensorDescription

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("DetailViewController", sender: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let tv = self.tableView {
                items.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }
}