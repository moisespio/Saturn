//
//  DetailViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/29/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tappedCloseButton(sender: UIViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
