//
//  SensorsTableViewCell.swift
//  
//
//  Created by Moisés Pio on 6/26/15.
//
//

import UIKit

class SensorsTableViewCell: UITableViewCell {
    @IBOutlet weak var identifier: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var statusIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
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
