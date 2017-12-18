//
//  ProfileViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 12/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var lbl_Username: UILabel!
    @IBOutlet var img_User: UIImageView!
    var userInfo : NSDictionary!
    var rootVC : UIViewController!
    @IBOutlet var lbl_email: UILabel!
    @IBOutlet var tbl_user: UITableView!
    @IBOutlet var img_profile_picture: UIImageView!
    var titleArray : NSArray!
    var imgArray : NSArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loaduserData()
        Utilities.homeNavigationMenu(rootVC:self)
        self.navigationController?.navigationItem.hidesBackButton = true
        //menu
        if(UserDefaults.standard.bool(forKey: "menu"))
        {
            let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(leftMenuAction))
            flipButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = flipButton
        }
        else
        {
            let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
            flipButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = flipButton
        }
    }
    
    func loaduserData()
    {
        self.userInfo = UserDefaults.standard.dictionary(forKey: "Userinfo")! as NSDictionary
        let imagDict = (userInfo!.value(forKey: "avatar") as! NSDictionary)
        let imageString = "\((imagDict.value(forKey: "path") as! String))\((imagDict.value(forKey: "name") as! String)).\((imagDict.value(forKey: "ext") as! String))"
        let image : UIImage = UIImage(named: "car")!
        self.img_profile_picture.kf.indicatorType = .activity
        self.img_profile_picture.kf.setImage(with: URL(string: "\(CommonHomeAPI)/\(imageString)")!, placeholder: image)
        img_profile_picture.layer.cornerRadius = img_profile_picture.frame.size.height / 2
        img_profile_picture.layer.borderWidth = 2.0
        img_profile_picture.layer.borderColor = UIColor.white.cgColor
        img_profile_picture.clipsToBounds = true
        img_profile_picture.layer.masksToBounds = true
        img_profile_picture.layoutIfNeeded()
        titleArray = ["Create Ads","Your Ads","Your Favourite Ads","Point Package","Your Points"];
        imgArray = ["cPlus","Ads","fav","points","sypoints"]
        //user_btn.titleLabel?.text = (userInfo.value(forKey: "username") as! String)
        lbl_Username.text = (userInfo!.value(forKey: "username") as! String)
        lbl_email.text = (userInfo!.value(forKey: "email") as! String)
    }
    @objc func leftMenuAction()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func UserSettings(_ sender: Any) {
        let updateProfile = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        self.navigationController?.pushViewController(updateProfile, animated: true)
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

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "profilecell")
        if(cell == nil)
        {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "profilecell")
        }
        cell?.textLabel?.textColor = UIColor.white
        cell?.accessoryType = .disclosureIndicator
         cell?.imageView?.image = UIImage(named: (self.imgArray.object(at: indexPath.row) as! String))
        cell?.textLabel?.text = (self.titleArray.object(at: indexPath.row) as! String)
        //cell?.contentView.backgroundColor = UIColor.black
        cell?.backgroundColor = UIColor.black
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 0)
        {
            let createAds = self.storyboard?.instantiateViewController(withIdentifier: "CreateAdViewController") as! CreateAdViewController
            self.navigationController?.pushViewController(createAds, animated: true)
        }
        else if(indexPath.row == 1)
        {
            let yourAds = self.storyboard?.instantiateViewController(withIdentifier: "YourAdsViewController") as! YourAdsViewController
            self.navigationController?.pushViewController(yourAds, animated: true)
        }
        else if(indexPath.row == 2)
        {
            let favView = self.storyboard?.instantiateViewController(withIdentifier: "YourFavoriteViewController") as! YourFavoriteViewController
            self.navigationController?.pushViewController(favView, animated: true)
        }
        else if(indexPath.row == 3)
        {
            let pointsView = self.storyboard?.instantiateViewController(withIdentifier: "PointsPackageViewController") as! PointsPackageViewController
            self.navigationController?.pushViewController(pointsView, animated: true)
        }
        else
        {
            let yourPoints = self.storyboard?.instantiateViewController(withIdentifier: "YourPointsViewController") as! YourPointsViewController
            self.navigationController?.pushViewController(yourPoints, animated: true)
        }
    }
}
