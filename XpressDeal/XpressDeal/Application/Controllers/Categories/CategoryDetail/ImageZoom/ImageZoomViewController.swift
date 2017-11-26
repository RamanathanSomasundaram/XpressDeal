//
//  ImageZoomViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 24/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class ImageZoomViewController: UIViewController {

    @IBOutlet var CV_imageFull: UICollectionView!
    @IBOutlet var fullView: UIView!
    @IBOutlet var CV_imageHalf: UICollectionView!
    var cv_fullImageFlowlayout : UICollectionViewFlowLayout!
    var cv_halfImageFlowlayout : UICollectionViewFlowLayout!
    var imageArray : NSArray!
    var imagetitle : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = imagetitle
        Utilities.homeNavigationMenu(rootVC: self)
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        CV_imageFull.register(UINib.init(nibName: "ImageviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageView")
        cv_fullImageFlowlayout = UICollectionViewFlowLayout()
        let size = (self.fullView.frame.size.width) * 1.203460
        cv_fullImageFlowlayout.itemSize = CGSize(width: self.fullView.frame.size.width, height: size)
        cv_fullImageFlowlayout.minimumLineSpacing = 1
        cv_fullImageFlowlayout.minimumInteritemSpacing = 1
        cv_fullImageFlowlayout.scrollDirection = .horizontal
        self.CV_imageFull.collectionViewLayout = cv_fullImageFlowlayout
        CV_imageFull.delegate = self
        CV_imageFull.dataSource = self
        self.CV_imageFull.reloadData()
        // Do any additional setup after loading the view.
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cv_fullImageFlowlayout = UICollectionViewFlowLayout()
        let size = (self.fullView.frame.size.width) * 1
        cv_fullImageFlowlayout.itemSize = CGSize(width: self.fullView.frame.size.width, height: size)
        cv_fullImageFlowlayout.minimumLineSpacing = 1
        cv_fullImageFlowlayout.minimumInteritemSpacing = 1
        cv_fullImageFlowlayout.scrollDirection = .horizontal
        self.CV_imageFull.collectionViewLayout = cv_fullImageFlowlayout
        CV_imageFull.delegate = self
        CV_imageFull.dataSource = self
        self.CV_imageFull.reloadData()
        cv_halfImageFlowlayout = UICollectionViewFlowLayout()
        cv_halfImageFlowlayout.itemSize = CGSize(width: 60, height: 60)
        cv_halfImageFlowlayout.minimumLineSpacing = 1
        cv_halfImageFlowlayout.minimumInteritemSpacing = 1
        cv_halfImageFlowlayout.scrollDirection = .horizontal
        self.CV_imageHalf.collectionViewLayout = cv_halfImageFlowlayout
        //CV_imageHalf.delegate = self
        //CV_imageHalf.dataSource = self
        self.CV_imageHalf.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImageZoomViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if(collectionView == CV_imageFull)
        {
            CV_imageFull.collectionViewLayout.invalidateLayout()
        }
        if(collectionView == CV_imageHalf)
        {
            CV_imageHalf.collectionViewLayout.invalidateLayout()
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell1 : UICollectionViewCell? = nil
        if(collectionView == CV_imageFull)
        {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath) as! ImageviewCollectionViewCell
        let dicValues = (self.imageArray.object(at: indexPath.row) as! NSDictionary)
        cell.configureCell(ImageURL: "\(CommonHomeAPI)\(dicValues.value(forKey: "thumb_b") as! String)")
            print("Full Image :\(CommonHomeAPI)\(dicValues.value(forKey: "thumb_s") as! String)")
        return cell
        }
        if(collectionView == CV_imageHalf)
        {
            let cell : UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHalf", for: indexPath)
            let Imageview : UIImageView = (cell?.viewWithTag(25)! as! UIImageView)
            let dicValues = (self.imageArray.object(at: indexPath.row) as! NSDictionary)
            let image : UIImage = UIImage(named: "car")!
            Imageview.sd_setShowActivityIndicatorView(true)
            Imageview.sd_setIndicatorStyle(.gray)
            Imageview.sd_setImage(with: URL(string: "\(CommonHomeAPI)\(dicValues.value(forKey: "thumb_m") as! String)")! , placeholderImage: image, options: .refreshCached)
            print("Half Image :\(CommonHomeAPI)\(dicValues.value(forKey: "thumb_b") as! String)")

            return cell!
        }
        return cell1!
    }
    
}
