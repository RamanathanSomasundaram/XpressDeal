//
//  PointsPackageViewController.swift
//  XpressDeal
//
//  Created by Lakeba_26 on 28/11/17.
//  Copyright © 2017 spiksolutions. All rights reserved.
//

import UIKit

class PointsPackageViewController: UIViewController {

    @IBOutlet var tbl_pointspackage: UITableView!
    var Pointspackage : NSDictionary!
    var PointsArray : NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PointsArray = NSMutableArray()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        Utilities.homeNavigationMenu(rootVC: self)
        Utilities.callSideMenu(rootVC: self)
        self.setupNavigationBarButton()
        self.loadPointsPackage()
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
    func loadPointsPackage()
    {
        if(Utilities.checkForInternet())
        {
            Utilities.showLoading()
            Alamofire.request("\(CommonHomeAPI)/index.php?option=com_djclassifieds&view=points&format=json", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    let jsonResult = ((json as AnyObject).value(forKey: "data")! as! NSDictionary)
                    self.Pointspackage = jsonResult
                    let jsonPoints = (jsonResult.value(forKey: "points") as! NSArray)
                    self.PointsArray = NSMutableArray(array: jsonPoints)
                }
                DispatchQueue.main.async {
                    self.tbl_pointspackage.register(UINib.init(nibName: "PointsTableViewCell", bundle: nil), forCellReuseIdentifier: "pointscell")
                    Utilities.hideLoading()
                    self.tbl_pointspackage.reloadData()
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
extension PointsPackageViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PointsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PointsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "pointscell") as! PointsTableViewCell
        let dicValues = (self.PointsArray.object(at: indexPath.row) as! NSDictionary)
        Utilities.viewBorderColor(ContentView: cell.customView)
        cell.lbl_pricepakke.text = (dicValues.value(forKey: "name") as! String)
        cell.lbl_points.text = "Points : \((dicValues.value(forKey: "points") as! String))"
        let pointsAvg = ((dicValues.value(forKey: "price") as! NSString).floatValue / (dicValues.value(forKey: "points") as! NSString).floatValue)
        cell.lbl_avgPoints.text = "Price per points : \(pointsAvg)"
        cell.lbl_price.text = "\((dicValues.value(forKey: "price") as! String))"
        cell.btn_buynow.tag = indexPath.row
        cell.btn_buynow.addTarget(self, action: #selector(buynowAction), for: .touchUpInside)
        //cell.cellConfigure(dicValues: dicValues)
        cell.layoutIfNeeded()
        return cell
    }
    @objc func buynowAction()
    {
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

