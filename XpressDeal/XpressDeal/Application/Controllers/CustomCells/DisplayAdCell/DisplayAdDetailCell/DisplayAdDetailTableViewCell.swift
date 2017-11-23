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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(dicValues : NSDictionary)
    {
        let image : UIImage = UIImage(named: "car")!
        self.img_detail.sd_setShowActivityIndicatorView(true)
        self.img_detail.sd_setIndicatorStyle(.gray)
        self.img_detail.sd_setImage(with: URL(string: "http://172.104.181.194/demos/dj/images.jpg") , placeholderImage: image, options: .refreshCached)
        self.createTitle.text = "Created By :"
        self.Lbl_phone.text = "Phone :"
        self.lbl_Email.text = "Email :"
        self.lbl_AddDate.text = "Added Date :"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
