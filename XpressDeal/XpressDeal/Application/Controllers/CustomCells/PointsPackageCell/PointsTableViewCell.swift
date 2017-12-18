//
//  PointsTableViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 17/12/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class PointsTableViewCell: UITableViewCell {

    @IBOutlet var customView: CardView!
    @IBOutlet var lbl_pricepakke: UILabel!
    @IBOutlet var lbl_points: UILabel!
    @IBOutlet var lbl_price: UILabel!
    @IBOutlet var lbl_avgPoints: UILabel!
    @IBOutlet var btn_buynow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
