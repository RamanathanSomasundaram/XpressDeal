//
//  ProfileViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 12/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//http://172.104.181.194/demos/dj/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&type=register&format=json&ignoreMessages=0&jform[name]=hariram&jform[username]=hari&jform[password1]=hari123&jform[password2]=hari123&jform[email1]=test@gmail.com&jform[email2]=test@gmail.com

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var lbl_Username: UILabel!
    @IBOutlet var img_User: UIImageView!
    var userInfo : NSDictionary!
    var rootVC : UIViewController!
    @IBOutlet var tbl_user: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userInfo = UserDefaults.standard.dictionary(forKey: "Userinfo")! as NSDictionary
        print("User Info : \(userInfo)")
        //user_btn.titleLabel?.text = (userInfo.value(forKey: "username") as! String)
        lbl_Username.text = (userInfo.value(forKey: "username") as! String)
        Utilities.homeNavigationMenu(rootVC:self)
        self.navigationController?.navigationItem.hidesBackButton = true
        //menu
        if(UserDefaults.standard.bool(forKey: "menu"))
        {
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(leftMenuAction))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
        }
        else
        {
            let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_back-40.png"), style: .plain, target: self, action: #selector(backHome))
            flipButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = flipButton
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func leftMenuAction()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    @objc func backHome()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func UserSettings(_ sender: Any) {
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

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "profilecell")
        if(cell == nil)
        {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "profilecell")
        }
        cell?.textLabel?.textColor = UIColor.white
        cell?.accessoryType = .disclosureIndicator
         cell?.imageView?.image = UIImage(named: "login.png")
        cell?.textLabel?.text = "welcome"
        //cell?.contentView.backgroundColor = UIColor.black
        cell?.backgroundColor = UIColor.black
        return cell!
    }
}
