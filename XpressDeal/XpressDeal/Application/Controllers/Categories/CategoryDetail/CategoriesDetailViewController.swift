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
    @IBOutlet var lbl_special: UILabel!
    @IBOutlet var lbl_location: UILabel!
    @IBOutlet var userReviewView: UIView!
    @IBOutlet var txtView_Desc: UITextView!
    var passingItemsDict : NSDictionary!
    @IBOutlet var btn_bids: UIButton!
    @IBOutlet var btn_buynow: UIButton!
    var displayDetailDict : NSDictionary!
    var detailID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetailDict = NSDictionary()
        Tbl_detail.register(UINib.init(nibName: "DisplayAdDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DisplayDetail")
            self.Tbl_detail.tableFooterView = UIView()
        self.loadCategoriesList()
        self.title = "XpressDeal"
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        // Do any additional setup after loading the view.
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadCategoriesList()
    {
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
            Alamofire.request("\(CommonHomeAPI)/index.php?option=com_djclassifieds&view=item&format=json&id=\(detailID!)").responseJSON { response in
                if let json = response.result.value {
                    let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                    self.displayDetailDict = jsonResult
                }
                let dispatchTime = DispatchTime.now()
                DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                    let dicValues = (self.displayDetailDict.value(forKey: "item")! as! NSDictionary)
                    self.passingItemsDict = dicValues
                    self.lbl_titleAd.text =  (dicValues.value(forKey:"name") as! String)
                    self.txtView_Desc.text = (dicValues.value(forKey:"description") as! String)
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
                    self.Tbl_detail.reloadData()
                    Utilities.hideLoading()
                })
            }
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
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
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
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
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
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
        }
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
        if(self.displayDetailDict.count > 0)
        {
        return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayDetail") as! DisplayAdDetailTableViewCell
        let image : UIImage = UIImage(named: "car")!
        let imageArray = (self.displayDetailDict.value(forKey: "item_images")! as! NSArray)
        let imageDict = (imageArray.object(at: indexPath.row) as! NSDictionary)
        Tbl_detail.backgroundColor = UIColor.black
        cell.img_detail.kf.indicatorType = .activity
        cell.img_detail.kf.setImage(with: URL(string: "http://172.104.181.194/demos/dj\((imageDict.value(forKey: "thumb_b") as! String))"), placeholder: image , options: [.processor(processor)])
        let dicValues = (self.displayDetailDict.value(forKey: "item")! as! NSDictionary)
        cell.imgClick.addTarget(self, action: #selector(imageZoom), for: .touchUpInside)
        cell.createTitle.text = "Created By : \(dicValues.value(forKey: "username")!)"
        cell.Lbl_phone.text = "Phone : test"
        cell.lbl_Email.text = "Email : \(dicValues.value(forKey: "u_email")!)"
        cell.lbl_AddDate.text = "Added Date : \(dicValues.value(forKey: "date_start")!)"
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
