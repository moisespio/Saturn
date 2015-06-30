//
//  MenuTableViewCell.swift
//  Saturn
//
//  Created by Moisés Pio on 6/30/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func drawRect(rect: CGRect) {
        var border = CALayer()
        var width = CGFloat(2.0)
        border.borderColor = UIColor(red: 222/255, green: 226/255, blue: 233/255, alpha: 1).CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 2)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
    }

}
