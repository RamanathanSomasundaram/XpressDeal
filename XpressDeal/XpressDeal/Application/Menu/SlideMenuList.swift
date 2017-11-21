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
    override func viewDidLoad() {
        commonAppDelegate = UIApplication.shared.delegate as! AppDelegate
        menuTitleList = commonAppDelegate.categoriesListArray
        tbl_schoolMenu.backgroundColor = UIColor.black
        Utilities.homeNavigationMenu(rootVC:self)
        tbl_schoolMenu.tableFooterView = UIView()
        self.tbl_schoolMenu.register(UINib.init(nibName: "ListParentTableViewCell", bundle: nil), forCellReuseIdentifier: "parentCell")
    }

    //MARK: - Tableview Datasource and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
        return menuTitleList.count
        }
        else
        {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "parentCell"
        let cell : ListParentTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! ListParentTableViewCell
        if(indexPath.section == 0)
        {
        let dicValues = menuTitleList.object(at: indexPath.row) as! NSDictionary
        cell.configureCell(dicValues: dicValues)
        }
        else
        {
            let dicValues = ["name" : "Login" , "app_icon" : "login.png"]
            cell.configureCell(dicValues: dicValues as NSDictionary)
        }
        cell.setNeedsLayout()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1)
        {
            if(!UserDefaults.standard.bool(forKey: "UserLogin"))
            {
            let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(login, animated: true)
            }
            else
            {
                UserDefaults.standard.set(false, forKey: "signIn")
                UserDefaults.standard.synchronize()
                let profileView = ProfileViewController.init(nibName: "ProfileViewController", root: self)
                self.navigationController?.pushViewController(profileView, animated: true)
            }
        }
        else
        {
        let dicValues = menuTitleList.object(at: indexPath.row) as! NSDictionary
        let menuList = self.storyboard?.instantiateViewController(withIdentifier: "MenuListViewController") as! MenuListViewController
        menuList.CategoryName = (dicValues.value(forKey: "name") as! String)
        self.navigationController?.pushViewController(menuList, animated: true)
        }
        //self.performSegue(withIdentifier: "login", sender: nil)
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

