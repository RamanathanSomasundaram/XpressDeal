//
//  LoginViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 07/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var loginData = NSDictionary()
    @IBOutlet var signin_Btn: UIButton!
    @IBOutlet var txt_username: SkyFloatingLabelTextField!
    @IBOutlet var txt_password: SkyFloatingLabelTextField!
    var ErrorMessage : String!

    @IBOutlet var img_logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        signin_Btn.layer.cornerRadius = signin_Btn.frame.size.height / 2
        img_logo.layer.cornerRadius = img_logo.frame.size.width / 2
        img_logo.layer.masksToBounds = true
        img_logo.clipsToBounds = true
        img_logo.layoutIfNeeded()
        //NavigationController background color
        //self.title = "XpressDeal"
        
        txt_username.delegate = self
        txt_username.tag = 256
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if(UserDefaults.standard.bool(forKey: "menu1"))
        {
            self.navigationController?.navigationItem.hidesBackButton = true
            Utilities.homeNavigationMenu(rootVC: self)
            Utilities.callSideMenu(rootVC: self)
            // Do any additional setup after loading the view.
            let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(leftMenuAction))
            flipButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = flipButton
        }
        else
        {
            Utilities.homeNavigationMenu(rootVC: self)
            self.navigationItem.hidesBackButton = true
            let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
            flipButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = flipButton
        }
    }
    @objc func leftMenuAction()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signInAction(_ sender: Any) {
        
        let inputFileds = [txt_username, txt_password]
        for fields in inputFileds
        {
            if (fields?.text?.isEmpty)!
            {
                Utilities.AnimationShakeTextField(textField: fields!)
                //CRNotifications.showNotification(type: .error, title: "Warning", message: "Required field", dismissDelay: 3.0)
                commonAppDelegate.window?.makeToast(message: "Required field", duration: 1.0, position: "bottom" as AnyObject)
                txt_username.errorMessage = ""
                txt_password.errorMessage = ""
                return
            }
        }
        Utilities.showLoading()
        var successMessage : String!
        Alamofire.request("\(signInAPI)username=\(txt_username.text!)&password=\(txt_password.text!)").responseJSON { response in
            if let json = response.result.value {
                let jsonMessage = ((json as AnyObject).value(forKey: "messages")! as! NSDictionary)
                if(jsonMessage.value(forKey: "error") != nil)
                {
                    self.ErrorMessage = ((jsonMessage.value(forKey: "error")! as AnyObject).object(at: 0) as! String)
                }
                else
                {
                    successMessage = ((jsonMessage.value(forKey: "success")! as AnyObject).object(at: 0) as! String)
                }
                let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                self.loginData = jsonResult
            }
            
            let dispatchTime = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: dispatchTime , execute: {
                Utilities.hideLoading()
                if((self.loginData.value(forKey: "status") as! NSNumber) != 1)
                {
                    self.txt_password.text = ""
                    self.txt_username.text = ""
                    commonAppDelegate.window?.makeToast(message: self.ErrorMessage, duration: 1.0, position: "center" as AnyObject)

                }
                else
                {
                    let userProfile = ["Username": self.txt_username.text! , "Password": self.txt_password.text!]
                    UserDefaults.standard.set(true, forKey: "UserLogin");
                    UserDefaults.standard.set(userProfile, forKey: "profile")
                    UserDefaults.standard.set(true, forKey: "signIn")
                    commonAppDelegate.window?.makeToast(message: successMessage, duration: 1.0, position: "center" as AnyObject)//menu
                    Alamofire.request("\(CommonHomeAPI)/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&format=json&type=getProfile", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                        
                            if let json = response.result.value {
                                let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                                UserDefaults.standard.set(jsonResult, forKey: "Userinfo")
                                UserDefaults.standard.synchronize()
                            }
                        
                        DispatchQueue.main.async {
                            if(UserDefaults.standard.bool(forKey: "menu1"))
                            {
                            UserDefaults.standard.set(true, forKey: "menu")
                            UserDefaults.standard.synchronize()
                            let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                            self.navigationController?.pushViewController(profileView, animated: true)
                            }
                            else
                            {
                                self.backHome()
                            }
                        UserDefaults.standard.synchronize()
                        }
                    }
                }
                self.txt_username.endEditing(true)
            })
        }
    }

    
    @IBAction func forgetPasswordAction(_ sender: Any) {
        let forgotPass = ForgetViewController.init(nibName: "ForgetViewController", bundle: nil)
        forgotPass.modalPresentationStyle = .overCurrentContext
        self.present(forgotPass, animated: true, completion: nil)
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
extension LoginViewController : UITextFieldDelegate
{
    /// Implementing a method on the UITextFieldDelegate protocol. This will notify us when something has changed on the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 256)
        {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if(text.contains("@"))
                {
                    if(!userTextFieldValidation.isValidEmail(Email: text))
                {
                        floatingLabelTextField.errorMessage = "Invalid email"
                }
                else
                {
                    floatingLabelTextField.errorMessage = ""
                }
                }
                else
                {
                    floatingLabelTextField.errorMessage = ""

                }
            }
        }
    }
        return true
    }
}
