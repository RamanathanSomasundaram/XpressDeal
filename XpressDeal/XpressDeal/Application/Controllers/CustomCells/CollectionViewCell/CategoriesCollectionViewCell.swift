//
//  CategoriesCollectionViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 05/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet var cardView: CardView!
    @IBOutlet var imgtitle: UILabel!
    @IBOutlet var customImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configurationCell(dicValues : NSDictionary)
    {
        let image : UIImage = UIImage(named: "car")!
        self.customImg.sd_setShowActivityIndicatorView(true)
        self.customImg.sd_setIndicatorStyle(.gray)
        self.customImg.sd_setImage(with: URL(string: (dicValues.value(forKey: "app_icon")! as! String))! , placeholderImage: image, options: .refreshCached)
        self.cardView.layer.borderWidth = 1.0
        self.cardView.layer.borderColor = UIColor.white.cgColor
        self.imgtitle.text = (dicValues.value(forKey: "name") as! String)
    }

}
