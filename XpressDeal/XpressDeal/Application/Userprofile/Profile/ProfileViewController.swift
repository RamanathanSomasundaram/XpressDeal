//
//  ProfileViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 12/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//http://172.104.181.194/demos/dj/index.php?option=com_ajax&group=xdajax&plugin=xpressDeal&type=register&format=json&ignoreMessages=0&jform[name]=hariram&jform[username]=hari&jform[password1]=hari123&jform[password2]=hari123&jform[email1]=test@gmail.com&jform[email2]=test@gmail.com

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var user_btn: UIButton!
    @IBOutlet var lbl_Username: UILabel!
    
    @IBOutlet var fastRating: UIView!
    var userInfo : NSDictionary!
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
        self.userInfo = UserDefaults.standard.dictionary(forKey: "Userinfo")! as NSDictionary
        print("User Info : \(userInfo)")
        user_btn.titleLabel?.text = (userInfo.value(forKey: "username") as! String)
        lbl_Username.text = (userInfo.value(forKey: "fullname") as! String)
        self.title = "XpressDeal"
        Utilities.homeNavigationMenu(rootVC:self)
        let flipButton = UIBarButtonItem.init(image: UIImage.init(named: "slidemenu.png"), style: .plain, target: self, action: #selector(leftMenuAction))
        flipButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = flipButton
//        if(!UserDefaults.standard.bool(forKey: "signIn"))
//        {
//        Utilities.callSideMenu(rootVC: self)
//        }

        // Do any additional setup after loading the view.
    }
    @objc func leftMenuAction()
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    @IBAction func userbtn_Action(_ sender: Any) {
    }

    @IBAction func addReviewAction(_ sender: Any) {
        let userReview = UserReviewViewController.init(nibName: "UserReviewViewController", root: self)
        userReview.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userReview, animated: true, completion: nil)
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
