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

    override func viewDidLoad() {
        super.viewDidLoad()
        signin_Btn.layer.cornerRadius = signin_Btn.frame.size.height / 2
        //NavigationController background color
        self.title = "XpressDeal"
        self.navigationController?.navigationItem.hidesBackButton = true
        Utilities.homeNavigationMenu(rootVC: self)
        Utilities.callSideMenu(rootVC: self)
        // Do any additional setup after loading the view.
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(leftMenuAction))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        txt_username.delegate = self
        txt_username.tag = 256
        
        // Do any additional setup after loading the view.
    }
    @objc func leftMenuAction()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
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
        Alamofire.request("\(signInAPI)username=\(txt_username.text!)&password=\(txt_password.text!)").responseJSON { response in
            if let json = response.result.value {
                let jsonMessage = ((json as AnyObject).value(forKey: "messages")! as! NSDictionary)
                if(jsonMessage.value(forKey: "error") != nil)
                {
                    self.ErrorMessage = ((jsonMessage.value(forKey: "error")! as AnyObject).object(at: 0) as! String)
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
                   // CRNotifications.showNotification(type: .error, title: "Login failed", message: self.ErrorMessage, dismissDelay: 1.0)
                    
                }
                else
                {
                    UserDefaults.standard.set(true, forKey: "UserLogin");
                    UserDefaults.standard.set(self.loginData, forKey: "Userinfo")
                    UserDefaults.standard.set(true, forKey: "signIn")
                    UserDefaults.standard.synchronize()
                    
                    //CRNotifications.showNotification(type: .success, title: "Success!", message: "You successfully logined", dismissDelay: 1.0)
                    let profileView = ProfileViewController.init(nibName: "ProfileViewController", root: self)
                    let navController = UINavigationController(rootViewController: profileView)
                    //self.present(profileView, animated: true, completion: nil)
                    self.navigationController?.present(navController, animated: true, completion: nil)
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
