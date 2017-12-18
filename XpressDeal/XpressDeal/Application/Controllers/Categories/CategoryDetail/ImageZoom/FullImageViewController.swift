//
//  FullImageViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 27/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet var imageSlideShow: ImageSlideshow!
    var imageArray : NSArray!
    var imagetitle : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = imagetitle
        var imageSource = [InputSource]()
        for i in 0..<self.imageArray.count
        {
            let dicValues = (self.imageArray.object(at: i) as! NSDictionary)
            imageSource.append(KingfisherSource.init(url: URL(string: "\(CommonHomeAPI)\((dicValues.value(forKey: "thumb_b") as! String))")!))
            
        }
        imageSlideShow.pageControlPosition = PageControlPosition.underScrollView
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.white
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        imageSlideShow.zoomEnabled = true
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.setImageInputs(imageSource)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        Utilities.homeNavigationMenu(rootVC: self)
        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        if(UserDefaults.standard.bool(forKey: "UserLogin"))
        {
            let flipRightButton = UIBarButtonItem.init(image: UIImage.init(named: "user"), style: .plain, target: self, action: #selector(profileView))
            flipRightButton.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = flipRightButton
        }
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
        self.imageArray = NSArray()
    }
    @objc func profileView()
    {
        UserDefaults.standard.set(false, forKey: "menu")
        UserDefaults.standard.synchronize()
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
