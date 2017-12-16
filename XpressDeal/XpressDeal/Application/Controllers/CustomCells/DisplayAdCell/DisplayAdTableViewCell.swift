//
//  DisplayAdTableViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 08/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class DisplayAdTableViewCell: UITableViewCell {

    @IBOutlet var catImg: UIImageView!
    @IBOutlet var CellView: UIView!
    @IBOutlet var catStart: UILabel!
    @IBOutlet var catDesc: UILabel!
    @IBOutlet var catTitle: UILabel!
    @IBOutlet var catRating: CosmosView!
    @IBOutlet var catEnd: UILabel!
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet var displayImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configurationCell(dicValues : NSDictionary)
    {
        self.catRating.isUserInteractionEnabled = false
        let image : UIImage = UIImage(named: "car")!
        self.catImg.kf.indicatorType = .activity
        self.catImg.kf.setImage(with: URL(string: "\(CommonHomeAPI)/\(dicValues.value(forKey: "images")! as! String)")!, placeholder: image , options: [.processor(processor)])
        self.catTitle.text = (dicValues.value(forKey: "title") as! String)
        self.catDesc.text = (dicValues.value(forKey: "description") as! String)
        self.catStart.text = (dicValues.value(forKey: "start_date") as! String)
        self.catEnd.text = (dicValues.value(forKey: "exp_date") as! String)
        if((dicValues.value(forKey: "rating") as? String) != nil)
        {
        self.catRating.rating = (((dicValues.value(forKey: "rating") as! NSString).doubleValue) / 2.0)
        }
        else
        {
            self.catRating.rating = 0.0
        }
        if((dicValues.value(forKey: "display") as! String) == "0")
        {
            displayImage.isHidden = true
            displayLabel.isHidden = true
        }
        else
        {
            displayImage.isHidden = false
            displayLabel.isHidden = false
            displayLabel.text = (dicValues.value(forKey: "display") as! String)
        }
        self.catImg.backgroundColor = UIColor.clear
        Utilities.viewBorderColor(ContentView: CellView)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
