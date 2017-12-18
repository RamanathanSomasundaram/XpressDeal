//
//  SignupViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 07/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    
    @IBOutlet var txt_fullName: SkyFloatingLabelTextField!
    @IBOutlet var signup_Btn: UIButton!
    @IBOutlet var txt_Username: SkyFloatingLabelTextField!
    @IBOutlet var txt_password: SkyFloatingLabelTextField!
    @IBOutlet var txt_confirmPassword: SkyFloatingLabelTextField!
    @IBOutlet var txt_Email: SkyFloatingLabelTextField!
    @IBOutlet var txt_confirmEmail: SkyFloatingLabelTextField!
    var emailString : String!
    var passwordString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signup_Btn.layer.cornerRadius = signup_Btn.frame.size.height / 2
        //Navigation Controller backbutton hide
        
        let inputFileds = [txt_fullName, txt_Username,txt_Email, txt_confirmEmail,txt_password ,txt_confirmPassword]
        
        for fields in inputFileds
        {
            fields?.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        Utilities.homeNavigationMenu(rootVC: self)
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let inputFileds = [txt_fullName, txt_Username,txt_Email, txt_confirmEmail,txt_password ,txt_confirmPassword]
        for fields in inputFileds
        {
            if (fields?.text?.isEmpty)!
            {
                Utilities.AnimationShakeTextField(textField: fields!)
                //CRNotifications.showNotification(type: .error, title: "Warning", message: "Required field", dismissDelay: 3.0)
                return
            }
        }
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
        let parameters = ["jform[name]":txt_fullName.text!,"jform[username]":txt_Username.text!,"jform[password1]":txt_password.text!,"jform[password2]":txt_confirmPassword.text!,"jform[email1]":txt_Email.text!,"jform[email2]":txt_confirmEmail.text!]
        Alamofire.upload(multipartFormData: { multipartFromData in
            for (key, value) in parameters {
                multipartFromData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: "http://172.104.181.194/demos/dj/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&type=register&format=json&ignoreMessages=0") { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let JSON = response.result.value {
                        let jsonResult = ((JSON as AnyObject).value(forKey: "data")! as! Bool)
                        let jsonResult1 = ((JSON as AnyObject).value(forKey: "messages")! as! NSDictionary)
                            if(jsonResult)
                            {
                                commonAppDelegate.window?.makeToast(message: ((jsonResult1.value(forKey: "success")! as AnyObject).object(at: 0) as! String), duration: 1.0, position: "center" as AnyObject)
                            }
                            else
                            {
                                commonAppDelegate.window?.makeToast(message: ((jsonResult1.value(forKey: "warning")! as AnyObject).object(at: 0) as! String), duration: 1.0, position: "center" as AnyObject)
                            }
                        Utilities.hideLoading()
                        self.backHome()
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                //CRNotifications.showNotification(type: .error, title: "SignUp failed", message: "Invalid Datas", dismissDelay: 1.0)
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

extension SignupViewController : UITextFieldDelegate
{
    /// Implementing a method on the UITextFieldDelegate protocol. This will notify us when something has changed on the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
            //Name
            if(textField.tag == 151)
            {
                if(!userTextFieldValidation.isValidFullName(UserName: text))
                {
                    floatingLabelTextField.errorMessage = "Invalid Name"

                }
                else
                {
                    floatingLabelTextField.errorMessage = ""
                }
            }
            //Username
            else if(textField.tag == 152)
            {
                // Get invalid characters
                let invalidChars = NSCharacterSet.alphanumerics.inverted
                
                // Attempt to find the range of invalid characters in the input string. This returns an optional.
                let range = text.rangeOfCharacter(from: invalidChars)
                
                if range != nil {
                    floatingLabelTextField.errorMessage = "Invalid UserName"
                    //return false
                } else {
                    // No invalid character, allow the change
                    //return true
                    floatingLabelTextField.errorMessage = ""
                }
            }
            //EmailAddress
            else if(textField.tag == 153)
            {
                if(!userTextFieldValidation.isValidEmail(Email: text))
                {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else
                {
                    floatingLabelTextField.errorMessage = ""
                }
                emailString = text
            }
            else if(textField.tag == 154)
            {
                if(text != emailString)
                {
                    floatingLabelTextField.errorMessage = "Confirm email not matched"
                }
                else
                {
                    floatingLabelTextField.errorMessage = ""
                }
            }
            //Password
            else if(textField.tag == 155)
            {
                floatingLabelTextField.errorMessage = ""
                passwordString = text
            }
            else if(textField.tag == 156)
            {
                if(text != passwordString)
                {
                    floatingLabelTextField.errorMessage = "Confirm password not matched"
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
        return true
    }
}
