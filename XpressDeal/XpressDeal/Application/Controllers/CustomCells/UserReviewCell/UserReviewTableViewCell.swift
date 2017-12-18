//
//  UserReviewTableViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 09/12/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class UserReviewTableViewCell: UITableViewCell {

    @IBOutlet var lbl_Date: UILabel!
    @IBOutlet var lbl_UserName: UILabel!
    @IBOutlet var lbl_desc: UILabel!
    @IBOutlet var starRating: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cellConfiguration(dicValues : NSDictionary)
    {
        lbl_UserName.text = (dicValues.value(forKey: "user_name") as! String)
        lbl_Date.text = (dicValues.value(forKey: "created") as! String)
        lbl_desc.text = (dicValues.value(forKey: "message") as! String)
        if((dicValues.value(forKey: "rating_list") as? NSArray) != nil)
        {
            let ratingArray = ((dicValues.value(forKey: "rating_list") as! NSArray).object(at: 0) as! NSDictionary)
            if(((ratingArray.value(forKey: "rating") as! NSString).doubleValue) <= 5.0)
            {
            self.starRating.rating = ((ratingArray.value(forKey: "rating") as! NSString).doubleValue)
            }
            else
            {
                self.starRating.rating = (((ratingArray.value(forKey: "rating") as! NSString).doubleValue) / 2.0)
            }
        }
        else
        {
            self.starRating.rating = 0.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
