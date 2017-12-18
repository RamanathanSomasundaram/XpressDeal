//
//  UpdateProfileViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 17/12/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController {

    @IBOutlet var lbl_name: SkyFloatingLabelTextField!
    @IBOutlet var lbl_username: SkyFloatingLabelTextField!
    @IBOutlet var lbl_email: SkyFloatingLabelTextField!
    @IBOutlet var lbl_website: SkyFloatingLabelTextField!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var passwordViewHeight: NSLayoutConstraint!
    @IBOutlet var lbl_password: SkyFloatingLabelTextField!
    @IBOutlet var lbl_confirmpass: SkyFloatingLabelTextField!
    @IBOutlet var lbl_dob: SkyFloatingLabelTextField!
    @IBOutlet var lbl_about: SkyFloatingLabelTextField!
    @IBOutlet var lbl_address1: SkyFloatingLabelTextField!
    @IBOutlet var lbl_address2: SkyFloatingLabelTextField!
    @IBOutlet var lbl_phone: SkyFloatingLabelTextField!
    @IBOutlet var lbl_city: SkyFloatingLabelTextField!
    @IBOutlet var lbl_country: SkyFloatingLabelTextField!
    @IBOutlet var lbl_postalcode: SkyFloatingLabelTextField!
    @IBOutlet var lbl_region: SkyFloatingLabelTextField!
    @IBOutlet var lbl_favBooks: SkyFloatingLabelTextField!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewHeight.constant = 725 - 75
        passwordViewHeight.constant = 0
        self.passwordView.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        Utilities.homeNavigationMenu(rootVC: self)
        Utilities.callSideMenu(rootVC: self)
        self.setupNavigationBarButton()
        self.loadUserData()
    }
    
    func setupNavigationBarButton()
    {
        self.navigationItem.hidesBackButton = true
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func loadUserData()
    {
        let userData = UserDefaults.standard.dictionary(forKey: "Userinfo")! as NSDictionary
        let userProfile = (userData.value(forKey: "profile") as! NSDictionary)
        lbl_name.text = (userData.value(forKey: "name") as! String)
        lbl_username.text = (userData.value(forKey: "username") as! String)
        lbl_email.text = (userData.value(forKey: "email") as! String)
        lbl_website.text = (userProfile.value(forKey: "website") as! String)
        lbl_dob.text = (userProfile.value(forKey: "dob") as! String)
        lbl_about.text = (userProfile.value(forKey: "aboutme") as! String)
        lbl_address1.text = (userProfile.value(forKey: "address1") as! String)
        lbl_address2.text = (userProfile.value(forKey: "address2") as! String)
        lbl_phone.text = (userProfile.value(forKey: "phone") as! String)
        lbl_city.text = (userProfile.value(forKey: "city") as! String)
        lbl_country.text = (userProfile.value(forKey: "country") as! String)
        lbl_postalcode.text = (userProfile.value(forKey: "postal_code") as! String)
        lbl_region.text = (userProfile.value(forKey: "region") as! String)
        lbl_favBooks.text = (userProfile.value(forKey: "favoritebook") as! String)
    }
    
    @IBAction func passwordAction(_ sender: Any) {
        if(passwordViewHeight.constant == 0)
        {
            self.passwordView.isHidden = false
            scrollViewHeight.constant = 725
            passwordViewHeight.constant = 75
        }
        else
        {
            self.passwordView.isHidden = true
            scrollViewHeight.constant = 725 - 75
            passwordViewHeight.constant = 0

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

