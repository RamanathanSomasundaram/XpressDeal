//
//  YourPointsViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 28/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class YourPointsViewController: UIViewController {

    @IBOutlet var lbl_userpoints: UILabel!
    @IBOutlet var tbl_yourpoints: UITableView!
    var userPoints : NSDictionary!
    var userPointsArray : NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        userPointsArray = NSMutableArray()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        Utilities.homeNavigationMenu(rootVC: self)
        Utilities.callSideMenu(rootVC: self)
        self.setupNavigationBarButton()
        self.loadUserpoints()
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
    func loadUserpoints()
    {
        if(Utilities.checkForInternet())
        {
        Utilities.showLoading()
        Alamofire.request("\(CommonHomeAPI)/index.php?option=com_djclassifieds&view=userpoints&format=json", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value {
                let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                self.userPoints = jsonResult
                let jsonPoints = (jsonResult.value(forKey: "points") as! NSArray)
                self.userPointsArray = NSMutableArray(array: jsonPoints)
            }
            DispatchQueue.main.async {
                self.tbl_yourpoints.register(UINib.init(nibName: "UserPointsTableViewCell", bundle: nil), forCellReuseIdentifier: "userpoints")
                self.lbl_userpoints.text = "Points Available :\((self.userPoints.value(forKey: "user_points") as! String))"
                Utilities.hideLoading()
                self.tbl_yourpoints.reloadData()
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
extension YourPointsViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userPointsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserPointsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "userpoints") as! UserPointsTableViewCell
        let dicValues = (self.userPointsArray.object(at: indexPath.row) as! NSDictionary)
        cell.cellConfigure(dicValues: dicValues)
        cell.layoutIfNeeded()
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
