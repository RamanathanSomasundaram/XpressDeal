//
//  CategoriesDetailViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 20/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//AIzaSyC2BwWCfZz3gZ5Ov7QnbNPnXXUlN_Y1dxY

import UIKit

class CategoriesDetailViewController: UIViewController {

    @IBOutlet var lbl_titleAd: UILabel!
    @IBOutlet var btn_addFav: UIButton!
    @IBOutlet var lvl_viteCount: UILabel!
    @IBOutlet var Tbl_detail: UITableView!
    @IBOutlet var lbl_location: UILabel!
    @IBOutlet var userReviewView: UIView!
    @IBOutlet var txtView_Desc: UILabel!
    var passingItemsDict : NSDictionary!
    @IBOutlet var btn_bids: UIButton!
    @IBOutlet var btn_buynow: UIButton!
    var displayDetailDict : NSDictionary!
    var detailID : String!
    @IBOutlet var tbl_specific: UITableView!
    @IBOutlet var contentHeight: NSLayoutConstraint!
    @IBOutlet var spl_ContentHeight: NSLayoutConstraint!
    @IBOutlet var tbl_userReview: UITableView!
    var fieldsDict = NSDictionary()
    var fieldsKey : NSMutableArray!
    var userReviewDict = NSDictionary()
    var userReviewKey : NSMutableArray!
    var tableHeight : CGFloat! = 0.0
    var spc_Height : CGFloat! = 0.0
    @IBOutlet var detailViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var descView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetailDict = NSDictionary()
        Tbl_detail.register(UINib.init(nibName: "DisplayAdDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DisplayDetail")
            self.Tbl_detail.tableFooterView = UIView()
            self.tbl_specific.tableFooterView = UIView()
        self.tbl_userReview.tableFooterView = UIView()
        fieldsKey = NSMutableArray()
        userReviewKey = NSMutableArray()
        self.loadCategoriesList()
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profileView()
    {
        UserDefaults.standard.set(false, forKey: "menu")
        UserDefaults.standard.synchronize()
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileView, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        Utilities.homeNavigationMenu(rootVC: self)
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
    func loadCategoriesList()
    {
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
            Alamofire.request("\(CommonHomeAPI)/index.php?option=com_djclassifieds&view=item&format=json&id=\(detailID!)").responseJSON { response in
                if let json = response.result.value {
                    let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                    if((jsonResult.value(forKey: "fields") as? NSDictionary) != nil)
                    {
                    let jsonFieldKey = (jsonResult.value(forKey: "fields") as! NSDictionary)
                    for (key,_) in jsonFieldKey
                    {
                        self.fieldsKey.add((key as! String))
                    }
                    self.fieldsDict = jsonFieldKey
                    }
                    else
                    {
                        self.spl_ContentHeight.constant = 0
                    }
                    self.displayDetailDict = jsonResult
                }
                
                let dispatchTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                    let dicValues = (self.displayDetailDict.value(forKey: "item")! as! NSDictionary)
                    self.passingItemsDict = dicValues
                    self.lbl_titleAd.text =  (dicValues.value(forKey:"name") as! String)
                    self.txtView_Desc.text = (dicValues.value(forKey:"description") as! String)
                    self.lbl_location.text = (dicValues.value(forKey:"address") as! String)
                    if((self.displayDetailDict.value(forKey: "bids")! as! NSArray).count > 0)
                    {
                        self.btn_bids.isHidden = false
                    }
                    else
                    {
                        self.btn_bids.isHidden = true
                    }//quantity
                    if(((dicValues.value(forKey: "quantity") as! NSString).integerValue) > 0)
                    {
                        self.btn_buynow.isHidden = false
                    }
                    else
                    {
                        self.btn_buynow.isHidden = true
                    }
                    self.txtView_Desc.sizeToFit()
                    self.txtView_Desc.layoutIfNeeded()
                    self.Tbl_detail.reloadData()
                    self.tbl_specific.reloadData()
                    Utilities.hideLoading()
                    self.loadUserReview()
                })
            }
        }
    }
    
    func loadUserReview()
    {
        Utilities.showLoading()
        Alamofire.request("\(CommonHomeAPI)/?option=com_djreviews&view=reviewslist&format=json&id=8&limitstart=0", method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let json = response.result.value {
                let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                if((jsonResult.value(forKey: "items")! as? NSDictionary) != nil)
                {
                let jsonDict = (jsonResult.value(forKey: "items")! as! NSDictionary)
                for (key,_) in jsonDict
                {
                    self.userReviewKey.add((key as! String))
                }
                self.userReviewDict = jsonDict
            }
            }
            let dispatchTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                self.tbl_userReview.register(UINib.init(nibName: "UserReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "userReviewCell")
                self.tbl_userReview.reloadData()
                Utilities.hideLoading()
                self.detailViewConstraint.constant = self.txtView_Desc.frame.size.height
                self.spl_ContentHeight.constant = self.tbl_specific.contentSize.height
                self.contentHeight.constant = 470 + self.txtView_Desc.frame.size.height + self.tbl_specific.contentSize.height + self.tbl_userReview.contentSize.height
            })
        }
    }
    
    @IBAction func userReviewAction(_ sender: Any) {
        let userReview = UserReviewViewController.init(nibName: "UserReviewViewController", root: self)
        userReview.modalPresentationStyle = .overCurrentContext
        self.present(userReview, animated: true, completion: nil)
    }
    
    @IBAction func showAdAction(_ sender: Any) {
        
    }
    
    @IBAction func socialAction(_ sender: Any) {
        
    }
    @IBAction func reportAction(_ sender: Any) {
        if(UserDefaults.standard.bool(forKey: "UserLogin"))
        {
        let report = ReportAbuseViewController.init(nibName: "ReportAbuseViewController", root: self)
            report.reportDict = ["item_id" : (passingItemsDict.value(forKey: "id") as! String) , "cid" : (passingItemsDict.value(forKey: "cat_id") as! String)]
            report.modalPresentationStyle = .overCurrentContext
        self.present(report, animated: true, completion: nil)
        }
        else
        {
            self.loginView()

        }
    }
    @objc func imageZoom()
    {
        let imageZoom = self.storyboard?.instantiateViewController(withIdentifier: "FullImageViewController") as! FullImageViewController
        imageZoom.imagetitle = self.lbl_titleAd.text
        imageZoom.imageArray = (self.displayDetailDict.value(forKey: "item_images")! as! NSArray)
        self.navigationController?.pushViewController(imageZoom, animated: true)
    }
    
    @IBAction func bidsAction(_ sender: Any) {
        if(UserDefaults.standard.bool(forKey: "UserLogin"))
        {
        let bids = self.storyboard?.instantiateViewController(withIdentifier: "BidsViewController") as! BidsViewController
        bids.bidsDict = (self.displayDetailDict.value(forKey: "bids")! as! NSArray)
        bids.bidMinMax = "Min --> \((passingItemsDict.value(forKey: "bid_min") as! String))        Max --> \((passingItemsDict.value(forKey: "bid_max") as! String))"
        self.navigationController?.pushViewController(bids, animated: true)
        }
        else
        {
            self.loginView()

        }
    }
    
    
    @IBAction func buyNowAction(_ sender: Any) {
        if(UserDefaults.standard.bool(forKey: "UserLogin"))
        {
            let Buynow = BuynowViewController.init(nibName: "BuynowViewController", root: self)
            Buynow.modalPresentationStyle = .overCurrentContext
            Buynow.buyDict = ["Price" : (passingItemsDict.value(forKey: "price") as! String) , "Quantity" : (passingItemsDict.value(forKey: "quantity") as! String) , "item_id" : (passingItemsDict.value(forKey: "id") as! String) , "cid" : (passingItemsDict.value(forKey: "cat_id") as! String)]
            self.present(Buynow, animated: true, completion: nil)
        }
        else
        {
            self.loginView()
        }
    }
    
    func loginView()
    {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
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

extension CategoriesDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tbl_userReview)
        {
            if(self.userReviewDict.count > 0)
            {
              return self.userReviewDict.count
            }
        }
        else if(tableView == tbl_specific)
        {
            if(self.fieldsDict.count > 0)
            {
                return self.fieldsDict.count
            }
        }
        else
        {
        if(self.displayDetailDict.count > 0)
        {
        return 1
        }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == Tbl_detail)
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayDetail") as! DisplayAdDetailTableViewCell
        let image : UIImage = UIImage(named: "car")!
        let imageArray = (self.displayDetailDict.value(forKey: "item_images")! as! NSArray)
        let imageDict = (imageArray.object(at: indexPath.row) as! NSDictionary)
        Tbl_detail.backgroundColor = UIColor.black
        cell.img_detail.kf.indicatorType = .activity
        cell.img_detail.kf.setImage(with: URL(string: "http://172.104.181.194/demos/dj\((imageDict.value(forKey: "thumb_b") as! String))"), placeholder: image)
        let dicValues = (self.displayDetailDict.value(forKey: "item")! as! NSDictionary)
        cell.imgClick.addTarget(self, action: #selector(imageZoom), for: .touchUpInside)
        cell.createTitle.text = "Created By : \(dicValues.value(forKey: "username")!)"
        cell.Lbl_phone.text = "Phone : test"
        cell.lbl_Email.text = "Email : \(dicValues.value(forKey: "u_email")!)"
        cell.lbl_AddDate.text = "Added Date : \(dicValues.value(forKey: "date_start")!)"
        cell.selectionStyle = .none
        cell.imgClick.layer.cornerRadius = 20
        cell.imgClick.layer.masksToBounds = true
        cell.imgClick.clipsToBounds = true
        cell.layoutIfNeeded()
        return cell
        }
        else if(tableView == tbl_userReview)
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "userReviewCell") as! UserReviewTableViewCell
            let ReviewData = (self.userReviewKey.object(at: indexPath.row) as! String)
            let ReviewValue = (self.userReviewDict.value(forKey: ReviewData) as! NSDictionary)
            cell.cellConfiguration(dicValues: ReviewValue)
            tbl_userReview.backgroundColor = UIColor.black
            tbl_userReview.separatorStyle = .none
            cell.selectionStyle = .none
            tableHeight = tableHeight + CGFloat(cell.frame.height)
            self.tableHeightCalculate()
            return cell
        }
        else
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "spcDetailCell")
            if(cell == nil)
            {
                cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "spcDetailCell")
            }
            let fieldsData = (self.fieldsKey.object(at: indexPath.row) as! String)
            let fieldValue = (self.fieldsDict.value(forKey: fieldsData) as! NSDictionary)
            cell?.textLabel?.textColor = UIColor.white
            cell?.detailTextLabel?.textColor = UIColor.white
            tbl_specific.separatorStyle = .none
            cell?.textLabel?.text = (fieldValue.value(forKey: "label") as! String)
            if((fieldValue.value(forKey: "value") as? String) != nil)
            {
            cell?.detailTextLabel?.text = (fieldValue.value(forKey: "value") as! String)
            }
            else
            {
                cell?.detailTextLabel?.text = "null"
            }
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = UIColor.black
            tbl_specific.backgroundColor = UIColor.black
            spc_Height = spc_Height + CGFloat((cell?.frame.height)!)
            self.tableSpcHeightCalculate()
            return cell!
        }
    }
    func tableHeightCalculate (){
        contentHeight.constant = 470 + self.txtView_Desc.frame.size.height + spc_Height + tableHeight
    }
    func tableSpcHeightCalculate ()
    {

        spl_ContentHeight.constant = spc_Height
        contentHeight.constant = 470 + self.txtView_Desc.frame.size.height + spc_Height + tableHeight
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tbl_userReview)
        {
            return UITableViewAutomaticDimension
        }
        else if(tableView == tbl_specific)
        {
            return UITableViewAutomaticDimension
        }
        else
        {
        return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tbl_userReview)
        {
            return 150
        }
        else if(tableView == tbl_specific)
        {
            return UITableViewAutomaticDimension
        }
        else
        {
            return UITableViewAutomaticDimension
        }
        
    }
    
}
