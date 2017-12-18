//
//  YourFavoriteViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 28/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class YourFavoriteViewController: UIViewController {
    @IBOutlet var tbl_favAds: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        Utilities.homeNavigationMenu(rootVC: self)
        Utilities.callSideMenu(rootVC: self)
        self.setupNavigationBarButton()
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
extension YourFavoriteViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "updateProfile")
        if(cell == nil)
        {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "updateProfile")
        }
        cell?.backgroundColor = UIColor.black
        cell?.contentView.backgroundColor = UIColor.black
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = "Ads"
        tbl_favAds.separatorStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

