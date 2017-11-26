//
//  DisplayAdDetailTableViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 21/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class DisplayAdDetailTableViewCell: UITableViewCell {

    @IBOutlet var ContentView: CardView!
    @IBOutlet var img_detail: UIImageView!
    @IBOutlet var createTitle: UILabel!
    @IBOutlet var Lbl_phone: UILabel!
    @IBOutlet var lbl_AddDate: UILabel!
    @IBOutlet var lbl_Email: UILabel!
    @IBOutlet var imgClick: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
