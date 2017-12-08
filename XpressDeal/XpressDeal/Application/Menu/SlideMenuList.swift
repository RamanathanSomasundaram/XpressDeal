//
//  SlideMenuList.swift
//  MusixxiRecorder
//
//  Created by Lakeba-026 on 06/12/16.
//  Copyright © 2016 Lakeba Corporation Pty Ltd. All rights reserved.
//

import UIKit


class SlideMenuList: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tbl_schoolMenu: UITableView!
    var menuTitleList = NSMutableArray()
    
    @IBOutlet var loginImage: UIImageView!
    @IBOutlet var loginTopViewConstraint: NSLayoutConstraint!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var emailID: UILabel!
    
    override func viewDidLoad() {
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        menuTitleList = commonAppDelegate.categoriesListArray
        tbl_schoolMenu.backgroundColor = UIColor.black
        Utilities.homeNavigationMenu(rootVC:self)
        tbl_schoolMenu.tableFooterView = UIView()
        self.tbl_schoolMenu.register(UINib.init(nibName: "ListParentTableViewCell", bundle: nil), forCellReuseIdentifier: "parentCell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!UserDefaults.standard.bool(forKey: "UserLogin"))
        {
            loginTopViewConstraint.constant = -80
            loginImage.image = UIImage(named: "login.png")
            loginBtn.setTitle("Login", for: .normal)
        }
        else
        {
            loginTopViewConstraint.constant = 0
            let userInfo = UserDefaults.standard.dictionary(forKey: "Userinfo")! as NSDictionary
            print("User Info : \(userInfo)")
            userName.text = (userInfo.value(forKey: "username") as! String)
            emailID.text = (userInfo.value(forKey: "email") as! String)
            userProfileImage.layer.cornerRadius = (userProfileImage.frame.size.width * userProfileImage.frame.size.height) / 2
            userProfileImage.image = UIImage(named: "circleUser.png")
            loginImage.image = UIImage(named: "login.png")
            loginBtn.setTitle("Logout", for: .normal)
        }
    }

    //MARK: - Tableview Datasource and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitleList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "parentCell"
        let cell : ListParentTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! ListParentTableViewCell
        let dicValues = menuTitleList.object(at: indexPath.row) as! NSDictionary
        cell.configureCell(dicValues: dicValues)
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dicValues = menuTitleList.object(at: indexPath.row) as! NSDictionary
        let menuList = self.storyboard?.instantiateViewController(withIdentifier: "MenuListViewController") as! MenuListViewController
        menuList.CategoryName = (dicValues.value(forKey: "name") as! String)
        self.navigationController?.pushViewController(menuList, animated: true)
        //self.performSegue(withIdentifier: "login", sender: nil)
    }

    @IBAction func LoginAction(_ sender: Any) {
        if(!UserDefaults.standard.bool(forKey: "UserLogin"))
        {
            UserDefaults.standard.set("true", forKey: "menu")
            UserDefaults.standard.synchronize()
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
        }
        else
        {
            let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure Logout?", preferredStyle: .alert)
            let alertOK = UIAlertAction(title: "Logout", style: .default, handler: { (action)->Void in
                UserDefaults.standard.set(false, forKey: "signIn")
                UserDefaults.standard.set(false, forKey: "UserLogin")
                UserDefaults.standard.set(nil, forKey: "Userinfo")
                UserDefaults.standard.set(nil, forKey: "profile")
                UserDefaults.standard.synchronize()
                //self.viewWillAppear(false)
                let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(home, animated: true)
                
            })
            let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            logOutAlert.addAction(alertOK)
            logOutAlert.addAction(alertCancel)
            self.present(logOutAlert, animated: true, completion: nil)
            
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

