//
//  UserPointsTableViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 17/12/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class UserPointsTableViewCell: UITableViewCell {

    @IBOutlet var containerView: CardView!
    @IBOutlet var lbl_desc: UILabel!
    @IBOutlet var lbl_date: UILabel!
    @IBOutlet var lbl_points: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func cellConfigure(dicValues : NSDictionary)
    {
        Utilities.viewBorderColor(ContentView: containerView)
        self.lbl_points.text = "Points :\((dicValues.value(forKey: "points") as! String))"
        self.lbl_date.text = (dicValues.value(forKey: "date") as! String)
        self.lbl_desc.text = (dicValues.value(forKey: "description") as! String)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
