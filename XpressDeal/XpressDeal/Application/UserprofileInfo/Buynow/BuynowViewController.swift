//
//  BuynowViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 06/12/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class BuynowViewController: UIViewController {
    @IBOutlet var lbl_avQuantity: UILabel!
    @IBOutlet var lbl_price: UILabel!
    @IBOutlet var txt_Quantity: SkyFloatingLabelTextField!
    @IBOutlet var lbl_total: UILabel!
    @IBOutlet var cardView: CardView!
    var buyDict : NSDictionary!
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
        Utilities.viewBorderColor(ContentView: cardView)
        lbl_price.text = "Price : \((buyDict.value(forKey: "Price") as! String))"
        lbl_avQuantity.text = "Avail.Quantity : \((buyDict.value(forKey: "Quantity") as! String))"
        lbl_total.text = "Total : 0"
        // Do any additional setup after loading the view.
    }
    @IBAction func buyAction(_ sender: Any) {
        if(Utilities.checkForInternet())
        {
            txt_Quantity.endEditing(true)
            Utilities.showLoading()
            let parameters = ["item_id" : (buyDict.value(forKey: "item_id") as! String) , "cid" : (buyDict.value(forKey: "cid") as! String) ,"quantity" : txt_Quantity.text! , "option" : "com_djclassifieds" ,"view" : "checkout","task" : "saveCheckout","ajax" :"1" ]
            Alamofire.request("http://172.104.181.194/demos/dj/", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    let message = ((json as AnyObject).value(forKey: "messages")! as! NSDictionary)//error
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
                    self.rootVC.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        rootVC.dismiss(animated: true, completion: nil)
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
extension BuynowViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        txt_Quantity.errorMessage = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
     textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    /// Implementing a method on the UITextFieldDelegate protocol. This will notify us when something has changed on the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
            if(((string as NSString).integerValue) > ((buyDict.value(forKey: "Quantity") as! NSString).integerValue) || (textField.text! == "" && ((string as NSString).integerValue) > ((buyDict.value(forKey: "Quantity") as! NSString).integerValue)))
            {
            floatingLabelTextField.errorMessage = "Please enter Available item quantity"
                lbl_total.text = "Total : 0"
            }
            
            else
            {
                floatingLabelTextField.errorMessage = ""
                lbl_total.text = "Total : \(((string as NSString).floatValue) * ((buyDict.value(forKey: "Price") as! NSString).floatValue))"
            }
        }
        return true
    }
}
