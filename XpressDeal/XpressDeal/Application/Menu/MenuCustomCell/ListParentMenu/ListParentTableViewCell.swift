//
//  ListParentTableViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 12/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class ListParentTableViewCell: UITableViewCell {

    @IBOutlet var appIcon: UIImageView!
    
    @IBOutlet var menuTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(dicValues : NSDictionary)
    {
            let image : UIImage = UIImage(named: "login")!
            appIcon.sd_setShowActivityIndicatorView(true)
            appIcon.sd_setIndicatorStyle(.gray)
            appIcon.sd_setImage(with: URL(string: (dicValues.value(forKey: "app_icon")! as! String))! , placeholderImage: image, options: .refreshCached)
            menuTitle.text = (dicValues.value(forKey: "name") as! String)
            menuTitle.adjustsFontSizeToFitWidth = true
            menuTitle.numberOfLines = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
