//
//  BidsViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 06/12/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class BidsViewController: UIViewController {

    @IBOutlet var txt_Price: SkyFloatingLabelTextField!
    @IBOutlet var priceViewTop: NSLayoutConstraint!
    @IBOutlet var tbl_bids: UITableView!
    var bidsDict : NSArray!
    var BitCountArray : NSArray!
    var bidMinMax : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "XpressDeal"
        BitCountArray = NSArray()
        Utilities.homeNavigationMenu(rootVC: self)
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        tbl_bids.tableFooterView = UIView()
        self.priceViewTop.constant = -40
        self.loadBitListAPI()
        // Do any additional setup after loading the view.
    }
    
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadBitListAPI()
    {
        if(Utilities.checkForInternet())
        {
            let bidsId = (self.bidsDict.object(at: 0) as! NSDictionary)
            var dicValues : NSDictionary!
            Utilities.showLoading()
            Alamofire.request("\(CommonHomeAPI)/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&type=getbid&format=json&id=\((bidsId.value(forKey: "item_id") as! String))").responseJSON { response in
                if let json = response.result.value {
                    let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                     dicValues = jsonResult
                    print(jsonResult)
                }
            
            let dispatchTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                self.BitCountArray = (dicValues?.value(forKey: "items")! as! NSArray)
                if((dicValues?.value(forKey: "bidactive") as! NSNumber).intValue != 0)
                {
                    self.priceViewTop.constant  = 0
                }
                else
                {
                    self.priceViewTop.constant = -40
                }
                //self.BitCountArray.add(displayDetailDict)
                self.tbl_bids.reloadData()
                Utilities.hideLoading()
            })
        }
        }
    }
    
    @IBAction func bidsAction(_ sender: Any) {
        if(txt_Price.text?.isEmpty)!
        {
            commonAppDelegate.window?.makeToast(message: "Enter Bid Amount", duration: 1.0, position: "center" as AnyObject)
        }
        else
        {
        let bidsId = (self.bidsDict.object(at: 0) as! NSDictionary)
        let priceValue = txt_Price.text
        let parameters = ["option":"com_djclassifieds","view":"item","task":"ajxsaveBid","id":"\((bidsId.value(forKey: "item_id") as! String))","bid": "\(priceValue!)"]
            Utilities.showLoading()
        Alamofire.request("http://172.104.181.194/demos/dj/", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let message = ((json as AnyObject).value(forKey: "messages")! as! NSDictionary)
                if((message.value(forKey: "success") as? NSArray) != nil)
                {
                    commonAppDelegate.window?.makeToast(message: ((message.value(forKey: "success") as! NSArray).object(at: 0) as! String), duration: 1.0, position: "center" as AnyObject)
                    print(message)
                }
                else
                {
                    commonAppDelegate.window?.makeToast(message: ((message.value(forKey: "error") as! NSArray).object(at: 0) as! String), duration: 1.0, position: "center" as AnyObject)
                    print(message)
                }
                Utilities.hideLoading()
            }
        }
        txt_Price.errorMessage = ""
        txt_Price.endEditing(true)
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

extension BidsViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BitCountArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bidsCell")
        let Cellview =  cell?.viewWithTag(1009)
        Utilities.viewBorderColor(ContentView: Cellview!)
        let userName = cell?.viewWithTag(1010) as! UILabel
        let dateLbl = cell?.viewWithTag(1011) as! UILabel
        let price = cell?.viewWithTag(1012) as! UILabel
        let dicValues = (self.BitCountArray.object(at: indexPath.row) as! NSDictionary)
        userName.text = (dicValues.value(forKey: "u_name") as! String)
        dateLbl.text = (dicValues.value(forKey: "date") as! String)
        price.text = (dicValues.value(forKey: "price") as! String)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension BidsViewController : UITextFieldDelegate{
    /// Implementing a method on the UITextFieldDelegate protocol. This will notify us when something has changed on the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                floatingLabelTextField.errorMessage = bidMinMax
            }
        return true
    }
}
