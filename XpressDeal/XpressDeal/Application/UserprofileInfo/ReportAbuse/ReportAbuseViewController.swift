//
//  ReportAbuseViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 20/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class ReportAbuseViewController: UIViewController {

    @IBOutlet var cardView: UIView!
    @IBOutlet var txtView_Report: IQTextView!
    var reportDict : NSDictionary!
    var rootVC : UIViewController!
    
    init(nibName nibNameOrNil: String, root parentViewController: UIViewController) {
        super.init(nibName: nibNameOrNil, bundle: nil)
        self.rootVC = parentViewController
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.viewBorderColor(ContentView:cardView)
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelAction(_ sender: Any) {
        rootVC.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendReportAction(_ sender: Any) {
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
            let parameters = ["abuse_message" : txtView_Report.text! ,"abuse_status": "0","option" : "com_djclassifieds" ,"view" : "item" , "cid" : (reportDict.value(forKey: "cid") as! String),"item_id" : (reportDict.value(forKey: "item_id") as! String),"task" : "abuse","ajax" :"1" ]
            Alamofire.request("http://172.104.181.194/demos/dj/", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    let message = ((json as AnyObject).value(forKey: "messages")! as! NSDictionary)//error
                    if((message.value(forKey: "success") as? NSArray) != nil)
                    {
                        commonAppDelegate.window?.makeToast(message: ((message.value(forKey: "success") as! NSArray).object(at: 0) as! String), duration: 1.0, position: "center" as AnyObject)
                    }
                    else
                    {
                        commonAppDelegate.window?.makeToast(message: ((message.value(forKey: "error") as! NSArray).object(at: 0) as! String), duration: 1.0, position: "center" as AnyObject)
                    }
                    Utilities.hideLoading()
                    self.rootVC.dismiss(animated: true, completion: nil)
                }
            }
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
