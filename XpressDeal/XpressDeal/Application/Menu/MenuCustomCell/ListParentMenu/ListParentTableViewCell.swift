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
            self.appIcon.kf.indicatorType = .activity
            self.appIcon.kf.setImage(with: URL(string: (dicValues.value(forKey: "app_icon")! as! String))!, placeholder: image , options: [.processor(processor)])
            menuTitle.text = (dicValues.value(forKey: "name") as! String)
            menuTitle.adjustsFontSizeToFitWidth = true
            menuTitle.numberOfLines = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
