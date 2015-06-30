//
//  MenuViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/29/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var addNewSensor: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addSensor(sender: UIButton) {
        self.slideMenuController()?.closeRight()
    }
    var items = ["Sobre", "FAQ", "Ajuda", "Contato"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: darkBlur)

        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)

        addNewSensor.layer.borderWidth = 2
        addNewSensor.layer.borderColor = UIColor.whiteColor().CGColor
//        addNewSensor.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: MenuTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! MenuTableViewCell
        
        cell.menuLabel.text = self.items[indexPath.row]
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("DetailViewController", sender: nil)
    }
}
