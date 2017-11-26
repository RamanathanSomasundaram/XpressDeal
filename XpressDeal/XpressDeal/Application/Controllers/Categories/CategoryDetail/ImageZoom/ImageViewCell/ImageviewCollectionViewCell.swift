//
//  ImageviewCollectionViewCell.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 24/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class ImageviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imgViewCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(ImageURL : String)
    {
        let image : UIImage = UIImage(named: "car")!
        self.imgViewCell.sd_setShowActivityIndicatorView(true)
        self.imgViewCell.sd_setIndicatorStyle(.gray)
        self.imgViewCell.sd_setImage(with: URL(string: ImageURL)! , placeholderImage: image, options: .refreshCached)
    }

}
