//
//  MenuViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/29/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var addNewSensor: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: darkBlur)

        blurView.frame = self.view.bounds
        self.view.addSubview(blurView)

        addNewSensor.layer.borderWidth = 1
        addNewSensor.layer.borderColor = UIColor.whiteColor().CGColor
        addNewSensor.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
